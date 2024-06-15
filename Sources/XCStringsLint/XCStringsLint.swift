import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

@main
struct XCStringsLint: ParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [Lint.self, Rules.self],
        defaultSubcommand: Lint.self
    )
}
