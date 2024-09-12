import Foundation
import PackagePlugin

@main
struct XCStringsLintBuildToolPlugin {
    private let fileManager = FileManager()
    let toolName = "XCStringsLint"

    enum Error: Swift.Error, CustomStringConvertible {
        case incorrectTargetType
        case missingConfigFile
        case multipleConfigFiles

        var description: String {
            switch self {
                case .incorrectTargetType:
                    return "Incorrect target type. Expected a source module target."
                case .missingConfigFile:
                    return "No configuration file found in target. Expected a configuration file matching `xcstringslint.yml`."
                case .multipleConfigFiles:
                    return "Multiple configuration files found in target."
            }
        }
    }

    private let configRegex = try! Regex("\\.?xcstringslint\\.ya?ml")
    func configPath(rootPath: Path, targetFiles: FileList?) throws -> String {
        let rootConfigs = try fileManager
            .contentsOfDirectory(atPath: rootPath.string)
            .filter({ $0.contains(configRegex) })

        let targetConfigs = targetFiles?
            .filter({ $0.path.lastComponent.contains(configRegex) })
            .map(\.path.string) ?? []

        if !targetConfigs.isEmpty && !rootConfigs.isEmpty {
            Diagnostics.remark("Found target config. Overriding root config.")
        }

        let config = (targetConfigs + rootConfigs).first

        if config == nil {
            throw Error.missingConfigFile
        } else if targetConfigs.count > 1 || rootConfigs.count > 1 {
            throw Error.multipleConfigFiles
        }

        Diagnostics.remark("Running xcstringslint using config file found at: \(config!)")
        return config!
    }

    func commandsForTarget(
        named targetName: String,
        files: FileList?,
        config: String,
        toolPath: Path
    ) throws -> [Command] {
        let displayName = "Running String Catalog linter for \(targetName)"

        let catalogs = files?.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        } ?? []

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(targetName)")
            return [] // no-op
        }

        let arguments: [CustomStringConvertible] = [
            "--config", config,
            "--reporter", "xcode",
        ] + catalogs.map(\.path)

        return [
            .buildCommand(
                displayName: displayName,
                executable: toolPath,
                arguments: arguments
            )
        ]
    }
}

// MARK: - BuildToolPlugin

extension XCStringsLintBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard target is SourceModuleTarget else {
            throw Error.incorrectTargetType
        }

        let toolPath = try context.tool(named: toolName).path
        let config = try configPath(
            rootPath: context.package.directory,
            targetFiles: target.sourceModule?.sourceFiles
        )

        return try commandsForTarget(
            named: target.name,
            files: target.sourceModule?.sourceFiles,
            config: config,
            toolPath: toolPath
        )
    }
}

// MARK: - XcodeBuildToolPlugin

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension XCStringsLintBuildToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let toolPath = try context.tool(named: toolName).path
        let config = try configPath(
            rootPath: context.xcodeProject.directory,
            targetFiles: target.inputFiles
        )

        return try commandsForTarget(
            named: target.displayName,
            files: target.inputFiles,
            config: config,
            toolPath: toolPath
        )
    }
}

#endif
