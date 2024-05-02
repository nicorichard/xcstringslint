import Foundation

struct Catalog: Decodable {
    var sourceLanguage: String
    var strings: [String: CatalogString]
    var version: String

    struct CatalogString: Decodable {
        var localizations: [String: Localization]?
        var comment: String?
        var extractionState: String?

        struct Localization: Decodable {
            var stringUnit: StringUnit?

            struct StringUnit: Decodable {
                var state: String
                var value: String
            }
        }
    }
}
