import Foundation

public struct Catalog: Decodable {
    var sourceLanguage: String
    var strings: [String: CatalogString]
    var version: String

    public struct CatalogString: Decodable {
        var localizations: [String: Localization]?
        var comment: String?
        var extractionState: String?

        public enum ExtractionState: String, Decodable {
            case manual
            case unknown

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                self = Self.init(rawValue: value) ?? .unknown
            }
        }

        public struct Localization: Decodable {
            var stringUnit: StringUnit?

            public struct StringUnit: Decodable {
                var state: State
                var value: String

                public enum State: String, Decodable {
                    case translated
                    case needsReview = "needs_review"
                    case unknown

                    public init(from decoder: Decoder) throws {
                        let container = try decoder.singleValueContainer()
                        let value = try container.decode(String.self)

                        self = Self.init(rawValue: value) ?? .unknown
                    }
                }
            }
        }
    }
}
