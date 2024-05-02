import Foundation

public struct Catalog: Decodable {
    var sourceLanguage: String
    var strings: [String: CatalogString]
    var version: String

    public struct CatalogString: Decodable {
        var localizations: [String: Localization]?
        var comment: String?
        var extractionState: String?

        public struct Localization: Decodable {
            var stringUnit: StringUnit?

            public struct StringUnit: Decodable {
                var state: String
                var value: String
            }
        }
    }
}
