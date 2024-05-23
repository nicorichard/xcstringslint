import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

@main
struct StringCatalogLinter: ParsableCommand {

    @Argument(help: "Path(s) to .xcstrings String Catalogs")
    private var paths: [String]

    @Flag(name: .customLong("requireAutomatic"))
    private var requireAutomatic: Bool = false

    @Option(name: .customLong("locale"))
    private var requireLocales: [String] = []

    @Option(name: .customLong("state"))
    private var requireStates: [String] = []

    mutating func run() throws {
        for path in paths {
            try run(path: path)
        }
    }

    func run(path: String) throws {
        let catalog = try StringCatalog.load(from: path)

        var rules: [Rule] = []

        if requireAutomatic {
            rules.append(
                Rules.RejectExtractionState(state: "manual")
            )
        }

        if !requireStates.isEmpty {
            rules.append(
                Rules.RequireLocalizationState(in: requireStates)
            )
        }

        rules.append(
            Rules.RequireLocale(locales: requireLocales)
        )

        let results = Validator(rules: rules, ignores: Ignore.default)
            .validate(catalog: catalog)

        for result in results {
            print("`\(result.key)` has validation issues")
            for validation in result.validations {
                print("  - \(validation.message)")
            }
        }

        if !results.isEmpty {
            print("""

            [Error]: Found \(results.count) validation issues in catalog: \(path)

            """)
            throw ExitCode.failure
        }
    }
}
