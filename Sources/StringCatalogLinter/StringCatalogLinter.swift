import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

@main
struct StringCatalogLinter: ParsableCommand {

    @Argument(help: "Path(s) to .xcstrings String Catalogs")
    private var paths: [String]

    @Option(name: .customLong("config"))
    private var config: String?

    @Option(name: .customLong(Rules.RequireExtractionState.name))
    private var requireExtractionState: String?

    @Option(name: .customLong(Rules.RejectExtractionState.name))
    private var rejectExtractionState: String?

    @Option(name: .customLong(Rules.RequireLocale.name), parsing: .upToNextOption)
    private var requireLocales: [String] = []

    @Option(name: .customLong(Rules.RequireLocalizationState.name))
    private var requireLocalizationStates: [String] = []

    @Option(name: .customLong(Rules.RejectLocalizationState.name))
    private var rejectLocalizationStates: [String] = []

    mutating func run() throws {
        for path in paths {
            try run(path: path)
        }
    }

    func run(path: String) throws {
        let catalog = try StringCatalog.load(from: path)

        let rules = if let config {
            buildRules(using: try Config.load(from: config))
        } else {
            buildRules()
        }

        let results = validate(catalog: catalog, with: rules)

        for result in results {
            print("Validation failed for key: `\(result.key)`")
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

    func buildRules(using config: Config) -> [Rule] {
        var rules: [Rule] = []

        for (ruleName, rule) in config.rules {
            switch ruleName {
            case Rules.RequireExtractionState.name:
                rules.append(
                    Rules.RequireExtractionState(in: rule.values)
                )
            case Rules.RejectExtractionState.name:
                rules.append(
                    Rules.RejectExtractionState(in: rule.values)
                )
            case Rules.RequireLocale.name:
                rules.append(
                    Rules.RequireLocale(in: rule.values)
                )
            case Rules.RequireLocalizationState.name:
                rules.append(
                    Rules.RequireLocalizationState(in: rule.values)
                )
            case Rules.RejectLocalizationState.name:
                rules.append(
                    Rules.RejectLocalizationState(in: rule.values)
                )
            default:
                break
            }
        }

        rules.append(contentsOf: buildRules())

        return rules
    }

    func buildRules() -> [Rule] {
        var rules: [Rule] = []

        if let requireExtractionState {
            rules.append(
                Rules.RequireExtractionState(state: requireExtractionState)
            )
        }

        if let rejectExtractionState {
            rules.append(
                Rules.RejectExtractionState(state: rejectExtractionState)
            )
        }

        if !requireLocales.isEmpty {
            rules.append(
                Rules.RequireLocale(in: requireLocales)
            )
        }

        if !requireLocalizationStates.isEmpty {
            rules.append(
                Rules.RequireLocalizationState(in: requireLocalizationStates)
            )
        }

        if !rejectLocalizationStates.isEmpty {
            rules.append(
                Rules.RejectLocalizationState(in: rejectLocalizationStates)
            )
        }

        return rules
    }

    func validate(catalog: StringCatalog, with rules: [Rule]) -> [Validator.Validation] {
        Validator(rules: rules, ignores: Ignore.default)
            .validate(catalog: catalog)
    }
}
