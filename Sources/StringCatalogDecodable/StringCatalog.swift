import Foundation

public struct StringCatalog: Decodable {
    public var sourceLanguage: String
    public var strings: [String: Entry]
    public var version: String

    public struct Entry: Decodable {
        public var localizations: [String: Localization]?
        public var comment: String?
        public var extractionState: String?
    }
}

public typealias VariationType = String
public typealias Variation = String
public typealias VariationMappings = [VariationType : [Variation : Localization]]

public enum Localization: Decodable {
    case single(StringUnit)
    case variable(VariationMappings)

    public enum CodingKeys: String, CodingKey {
        case stringUnit
        case variations
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let stringUnit = try container.decodeIfPresent(StringUnit.self, forKey: .stringUnit) {
            self = .single(stringUnit)
        } else {
            let variations = try container.decode(VariationMappings.self, forKey: .variations)

            self = .variable(variations)
        }
    }

    public struct StringUnit: Decodable {
        public var state: String
        public var value: String
    }
}

extension Localization {
    public var stringUnits: [StringUnit] {
        switch self {
            case .single(let unit): return [unit]
            case .variable(let variants): return variants.values.flatMap { variation in
                variation.values.flatMap { $0.stringUnits }
            }
        }
    }
}
