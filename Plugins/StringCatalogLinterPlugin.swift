import Foundation
import PackagePlugin

let toolName = "StringCatalogLinter"

@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let targets = context.package.targets.filter { $0 is SourceModuleTarget }
        return try targets.flatMap { try commandsForTarget(context: context, target: $0) }
    }

    private func commandsForTarget(context: PluginContext, target: Target) throws -> [Command] {
        let toolPath = try context.tool(named: toolName).path
        let displayName = "Running String Catalog linter for \(target.name)"

        let catalogs = target.sourceModule?.sourceFiles.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        } ?? []

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(target.name)")
        }

        return catalogs.map { catalog in
            let arguments: [CustomStringConvertible] = [
                catalogs.first!.path
            ]

            return .buildCommand(
                displayName: displayName,
                executable: toolPath,
                arguments: arguments
            )
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let toolPath = try context.tool(named: toolName).path

        let displayName = "Running String Catalog linter for \(target.displayName)"

        let catalogs = target.inputFiles.filter {
            $0.path.lastComponent.hasSuffix(".xcstrings")
        }

        if catalogs.isEmpty {
            Diagnostics.warning("No xcstrings files found in \(target.displayName)")
        }

        return catalogs.map { catalog in
            let arguments: [CustomStringConvertible] = [
                catalog.path
            ]

            return .buildCommand(
                displayName: displayName,
                executable: toolPath,
                arguments: arguments
            )
        }
    }
}

#endif
