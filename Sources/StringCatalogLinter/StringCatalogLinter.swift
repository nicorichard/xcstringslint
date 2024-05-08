import Foundation
import StringCatalogValidator
import ArgumentParser

@main
struct StringCatalogLinter: ParsableCommand {

    @Argument(help: "Path(s) to .xcstrings String Catalogs")
    private var paths: [String]

    @Flag
    private var requireManual: Bool = false

    @Flag
    private var requireAutomatic: Bool = false

    @Option(name: .customLong("requireLocale"))
    private var requireLocales: [String] = []

    @Option(name: .customLong("requireState"))
    private var requireState: String?

    mutating func run() throws {
        for path in paths {
            try run(path: path)
        }
    }

    func run(path: String) throws {
        let catalog = try StringCatalogLoader().loadCatalog(from: path)

        var rules: [Rule] = []

        if requireManual {
            rules.append(
                Rules.requireManual
            )
        }

        if requireAutomatic {
            rules.append(
                Rules.requireAutomatic
            )
        }

        if let requireState {
            rules.append(
                Rules.requireLocalizationState(state: requireState)
            )
        }

        rules.append(
            Rules.requireLocale(locales: requireLocales)
        )

        let results = Validator(rules: rules, ignores: Ignore.default)
            .validate(catalog: catalog)

        for result in results {
            print("`\(result.key)` \(result.validation.message)")
        }

        if !results.isEmpty {
            print("""

            [Error]: Found \(results.count) validation issues in catalog: \(path)

            """)
            throw ExitCode.failure
        }
    }
}
