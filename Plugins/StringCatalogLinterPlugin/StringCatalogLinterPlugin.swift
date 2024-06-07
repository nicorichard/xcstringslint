import Foundation
import PackagePlugin

let toolName = "XCStringsLint"
let configRegex = try! Regex("\\.?xcstringslint\\.ya?ml")

@main
struct StringCatalogLinterPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let targets = context.package.targets.filter { $0 is SourceModuleTarget }
        return try targets.flatMap { try commandsForTarget(context: context, target: $0) }
    }

    private func commandsForTarget(context: PluginContext, target: Target) throws -> [Command] {
        let toolPath = try context.tool(named: toolName).path
        let displayName = "Running String Catalog linter for \(target.name)"

        let config = target.sourceModule?.sourceFiles.filter {
            $0.path.lastComponent.contains(configRegex)
        } ?? []

        if config.isEmpty {
            Diagnostics.error("No configuration file found in \(target.name). Expected a configuration file matching `xcstringslint.yml`.")
        } else if config.count > 1 {
            Diagnostics.error("Multiple configuration files found for \(target.name)")
        }

        let catalogs = target.sourceModule?.sourceFiles.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        } ?? []

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(target.name)")
            return [] // no-op
        }

        let arguments: [CustomStringConvertible] = [
            "--config", config.first!.path
        ] + catalogs.map(\.path)

        return [
            .buildCommand(
                displayName: displayName,
                executable: toolPath,
                arguments: arguments,
                inputFiles: catalogs.map(\.path)
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

        let config = target.inputFiles.filter {
            $0.path.lastComponent.contains(configRegex)
        }

        if config.isEmpty {
            Diagnostics.error("No configuration file found in \(target.displayName). Expected a configuration file matching `xcstringslint.yml`.")
        } else if config.count > 1 {
            Diagnostics.error("Multiple configuration files found for \(target.displayName)")
        }

        let catalogs = target.inputFiles.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        }

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(target.displayName)")
            return [] // no-op
        }

        let arguments: [CustomStringConvertible] = [
            "--config", config.first!.path
        ] + catalogs.map(\.path)

        return [
            .buildCommand(
                displayName: displayName,
                executable: toolPath,
                arguments: arguments,
                inputFiles: catalogs.map(\.path)
            )
        ]
    }
}

#endif
