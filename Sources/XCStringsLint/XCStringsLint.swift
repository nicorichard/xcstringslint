import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

@main
struct xcstringslint: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Validate xcstrings",
        discussion: "Ensure string catalog changes always meet your team's localization requirements.",
        subcommands: [Lint.self, Rules.self],
        defaultSubcommand: Lint.self
    )
}
