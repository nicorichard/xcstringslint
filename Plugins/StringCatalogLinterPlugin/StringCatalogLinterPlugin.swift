import Foundation
import PackagePlugin

let toolName = "XCStringsLint"
let configRegex = try! Regex("\\.?xcstringslint\\.ya?ml")

@main
struct StringCatalogLinterPlugin: BuildToolPlugin {

    let fileManager = FileManager()

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

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard target is SourceModuleTarget else {
            throw Error.incorrectTargetType
        }

        return try commandsForTarget(context: context, target: target)
    }

    private func configPath(rootPath: Path, targetFiles: FileList?) throws -> String {
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

    private func commandsForTarget(context: PluginContext, target: Target) throws -> [Command] {
        let toolPath = try context.tool(named: toolName).path
        let displayName = "Running String Catalog linter for \(target.name)"

        let config = try configPath(rootPath: context.package.directory, targetFiles: target.sourceModule?.sourceFiles)

        let catalogs = target.sourceModule?.sourceFiles.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        } ?? []

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(target.name)")
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

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension StringCatalogLinterPlugin: XcodeBuildToolPlugin {

    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let toolPath = try context.tool(named: toolName).path

        let displayName = "Running String Catalog linter for \(target.displayName)"

        let config = try configPath(
            rootPath: context.xcodeProject.directory,
            targetFiles: target.inputFiles
        )

        let catalogs = target.inputFiles.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        }

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(target.displayName)")
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

#endif
