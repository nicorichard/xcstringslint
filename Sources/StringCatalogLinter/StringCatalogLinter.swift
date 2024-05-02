import Foundation
import Validator
import ArgumentParser

@main
struct StringCatalogLinter: ParsableCommand {

    @Argument(help: "Path to the xcstrings catalog")
    private var path: String

    @Flag
    private var manualOnly: Bool = false

    mutating func run() throws {
        let catalog = try StringCatalogLoader().loadCatalog(from: path)

        var rules: [Rule] = []

        // TODO: Make the rules come from arguments or config file
        if (true) {
            rules.append(Rules.requireManual)
            rules.append(Rules.disallowManual)
            rules.append(Rules.requireTranslation(languages: "en", "fr"))
        }

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
