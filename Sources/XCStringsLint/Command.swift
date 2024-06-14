import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

@main
struct Command: ParsableCommand {

    @Argument(help: "Path(s) to .xcstrings String Catalogs")
    private var paths: [String]

    @Option(name: .customLong("config"))
    // TODO: if null, find the file in the current directory
    private var configPath: String

    @Option
    private var reporter: ReporterFactory = .xcode

    mutating func run() throws {
        for path in paths {
            try run(path: path)
        }
    }

    func run(path: String) throws {
        let catalog = try StringCatalog.load(from: path)
        let config = try Config.load(from: configPath)
        let rules = try config.toDomain()

        let results = Validator(rules: rules, ignores: Ignore.default)
            .validate(catalog: catalog)

        try reporter.build(path: path)
            .report(results: results)
    }
}
