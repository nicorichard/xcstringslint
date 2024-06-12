import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

@main
struct Command: ParsableCommand {

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

    @Option(name: .customLong(Rules.RequireLocalizationState.name), parsing: .upToNextOption)
    private var requireLocalizationStates: [String] = []

    @Option(name: .customLong(Rules.RejectLocalizationState.name), parsing: .upToNextOption)
    private var rejectLocalizationStates: [String] = []

    @Option
    private var reporter: ReporterFactory = .xcode

    mutating func run() throws {
        for path in paths {
            try run(path: path)
        }
    }

    func run(path: String) throws {
        let catalog = try StringCatalog.load(from: path)

        let rules = if let config {
            try buildRules(using: try Config.load(from: config))
        } else {
            buildRules()
        }

        let results = Validator(rules: rules, ignores: Ignore.default)
            .validate(catalog: catalog)

        try reporter.build(path: path)
            .report(results: results)
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

    func buildRules(using config: Config) throws -> [Rule] {
        var rules = try config.rules.compactMap { (ruleName, rule) -> Rule? in
            switch ruleName {
                case Rules.RequireExtractionState.name:
                    var domainRule = Rules.RequireExtractionState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RejectExtractionState.name:
                    var domainRule = Rules.RejectExtractionState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RequireLocale.name:
                    var domainRule = Rules.RequireLocale(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RequireLocalizationState.name:
                    var domainRule = Rules.RequireLocalizationState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RejectLocalizationState.name:
                    var domainRule = Rules.RejectLocalizationState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                default:
                    throw ValidationError("Unknown rule: \(ruleName)")
            }
        }

        rules.append(contentsOf: buildRules())

        return rules
    }
}
