import Foundation

public struct StringCatalog: Decodable {
    public var sourceLanguage: String
    public var strings: [String: Entry]
    public var version: String

    public struct Entry: Decodable {
        public var localizations: [String: Localization]?
        public var comment: String?
        public var extractionState: String?

        public enum ExtractionState: Decodable {
            case manual
            case unknown(key: String)

            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)

                self = switch value {
                    case "manual": .manual
                    default: .unknown(key: value)
                }
            }
        }

        public enum Localization: Decodable {
            case single(StringUnit)
            case variable([Variant])

            public enum CodingKeys: String, CodingKey {
                case stringUnit
                case variations
            }

            public enum Variant {
                case device([String: Localization])
                case plural([String: Localization])
                case unknown(key: String, [String: Localization])
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                if let stringUnit = try container.decodeIfPresent(StringUnit.self, forKey: .stringUnit) {
                    self = .single(stringUnit)
                } else {
                    let variations = try container.decode([String: [String: Localization]].self, forKey: .variations)

                    let variants: [Variant] = variations.map { key, value in
                        switch key {
                            case "device": return .device(value)
                            case "plural": return .plural(value)
                            default: return .unknown(key: key, value)
                        }
                    }

                    self = .variable(variants)
                }
            }

            public struct StringUnit: Decodable {
                public var state: State
                public var value: String

                public enum State: Decodable {
                    case new
                    case translated
                    case needsReview
                    case unknown(key: String)

                    public init(from decoder: Decoder) throws {
                        let container = try decoder.singleValueContainer()
                        let value = try container.decode(String.self)

                        self = switch value {
                            case "new": .new
                            case "translated": .translated
                            case "needs_review": .needsReview
                            default: .unknown(key: value)
                        }
                    }
                }
            }
        }
    }
}

extension StringCatalog.Entry.Localization {
    public var allUnits: [StringUnit] {
        switch self {
            case .single(let unit): return [unit]
            case .variable(let variants): return variants.flatMap { variant in
                switch variant {
                    case .device(let dictionary):
                        dictionary.values.flatMap { $0.allUnits }
                    case .plural(let dictionary):
                        dictionary.values.flatMap { $0.allUnits }
                    case .unknown(_, let dictionary):
                        dictionary.values.flatMap { $0.allUnits }
                }
            }
        }
    }
}
