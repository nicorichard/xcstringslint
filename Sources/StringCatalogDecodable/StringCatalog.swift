import Foundation

public struct StringCatalog: Decodable {
    public var sourceLanguage: String
    public var strings: [String: Entry]
    public var version: String

    public struct Entry: Decodable {
        public var localizations: [String: Localization]?
        public var comment: String?
        public var extractionState: String?

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
            public var stringUnit: StringUnit?

            public struct StringUnit: Decodable {
                public var state: State
                public var value: String

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
