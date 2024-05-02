import Foundation
import ArgumentParser

/*
 Purpose: To warn, or fail, when a xcstrings key is not translated for the specified languages

 Feature: Allow a comment tag to ignore
 Feature: Allow or dissalow automatic translations
 Feature: Allow or dissalow manual translations

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
            rules.append(ManualOnlyRule())
        }

        let validations = rules.flatMap { $0.run(catalog: catalog) }

        for validation in validations {
            print("`\(validation.key)` \(validation.message)")
        }

        if !validations.isEmpty {
            print("""

            Error: Found \(validations.count) validation issues in catalog: \(path)

            """)
            throw ExitCode.failure
        }
    }
}
