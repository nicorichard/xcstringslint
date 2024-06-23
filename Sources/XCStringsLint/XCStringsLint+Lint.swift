import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

extension XCStringsLint {
    struct Lint: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "lint"
        )

        // TODO: Add support for automatic discovery of .xcstrings files if no path is provided
        @Argument(help: "Path(s) to .xcstrings String Catalogs")
        private var paths: [String]

        @Option(name: .customLong("config"))
        private var configPath: String?

        @Option
        private var reporter: ReporterFactory = .xcode

        mutating func run() throws {
            for path in paths {
                try run(path: path)
            }
        }

        func run(path: String) throws {
            let catalog = try StringCatalog.load(from: path)
            let config = try Config.load(from: resolveConfigFilePath())
            let rules = try config.toDomain()

            let results = Validator(rules: rules, ignores: Ignore.default)
                .validate(catalog: catalog)

            try reporter.build(path: path)
                .report(results: results)
        }
    }
}

// MARK: - Config Resolving

extension XCStringsLint.Lint {
    private func findConfig(atPath path: String) throws -> String? {
        try FileManager.default
            .contentsOfDirectory(atPath: path)
            .filter({ $0.contains(configRegex) })
            .first
    }

    func resolveConfigFilePath() throws -> String {
        let found: String?

        if let configPath {
            if FileManager.default.isDirectory(atPath: configPath) {
                found = try findConfig(atPath: configPath)
            } else {
                found = configPath
            }
        } else {
            found = try findConfig(atPath: FileManager.default.currentDirectoryPath)
        }

        guard let found else {
            throw ValidationError("No xcstringslint config file could be found")
        }

        return found
    }
}

extension FileManager {
    func isDirectory(atPath path: String) -> Bool {
        var fileIsDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &fileIsDirectory)
        return exists && fileIsDirectory.boolValue
    }
}

private let configRegex = try! Regex("\\.?xcstringslint\\.ya?ml")
