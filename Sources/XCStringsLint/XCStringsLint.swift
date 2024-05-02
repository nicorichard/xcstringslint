import Foundation
import Validator
import ArgumentParser

/*
 Purpose: To warn, or fail, when a xcstrings key is not translated for the specified languages

 Feature: Allow a comment tag to ignore
 Feature: Allow or dissallow automatic translations
 Feature: Allow or dissallow manual translations

 */

@main
struct XCStringsLint: ParsableCommand {

    @Argument(help: "Path to the xcstrings catalog")
    private var path: String

    @Flag
    private var manualOnly: Bool = false

    mutating func run() throws {
        let catalog = try CatalogLoader().loadCatalog(from: path)

        var rules: [Rule] = []

        if (true) {
//            rules.append(Rules.requireManual)
//            rules.append(Rules.disallowManual)
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
