import Foundation
import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let targets = context.package.targets.filter { $0 is SourceModuleTarget }
        return try targets.map { try makeBuildCommand(context: context, target: $0) }
    }

    private func makeBuildCommand(context: PluginContext, target: Target) throws -> Command {
        let toolPath = try context.tool(named: "XCStringsLint").path

        let displayName = "Running String Catalog linter for \(target.name)"
        let packageDirectoryPath = context.package.directory.string
        let targetDirectoryPath = target.directory.string

        target.sourceModule?.sourceFiles.forEach {
            print("!@# \($0.path)")
        }

        let arguments: [CustomStringConvertible] = [
            // TODO: The tool might need to find the resources itself
        ]

        return .buildCommand(
            displayName: displayName,
            executable: toolPath,
            arguments: arguments
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let toolPath = try context.tool(named: "XCStringsLint").path

        let displayName = "Running String Catalog linter for \(target.displayName)"
        let projectDirectoryPath = context.xcodeProject.directory.string

        // TODO: Find the .xcstrings files and validate them

        target.inputFiles.forEach {
            print("!@# \($0.path)")
        }

        let arguments: [CustomStringConvertible] = []

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
