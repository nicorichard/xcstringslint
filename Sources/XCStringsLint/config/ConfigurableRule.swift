import StringCatalogValidator

enum ConfigurableRule: CaseIterable {
    case requireExtractionState
    case rejectExtractionState
    case requireLocale
    case requireLocalizationState
    case rejectLocalizationState
    case requireComment
    case requireMatchingPlaceholders
    case rejectEmptyValues
    case rejectPatterns
    case requirePositionalPlaceholders
    case requireObjectPlaceholders

    var type: (Rule & Decodable).Type {
        switch self {
            case .requireExtractionState: Rules.RequireExtractionState.self
            case .rejectExtractionState: Rules.RejectExtractionState.self
            case .requireLocale: Rules.RequireLocale.self
            case .requireLocalizationState: Rules.RequireLocalizationState.self
            case .rejectLocalizationState: Rules.RejectLocalizationState.self
            case .requireComment: Rules.RequireComment.self
            case .requireMatchingPlaceholders: Rules.RequireMatchingPlaceholders.self
            case .rejectEmptyValues: Rules.RejectEmptyValues.self
            case .rejectPatterns: Rules.RejectPatterns.self
            case .requirePositionalPlaceholders: Rules.RequirePositionalPlaceholders.self
            case .requireObjectPlaceholders: Rules.RequireObjectPlaceholders.self
        }
    }

    init?(name: String) {
        guard let entry = Self.allCases.first(where: { $0.type.name == name }) else { return nil }
        self = entry
    }
}

extension Rules.RequireExtractionState: Decodable {
    enum CodingKeys: String, CodingKey {
        case values
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
        self.init(in: values)
    }
}

extension Rules.RejectExtractionState: Decodable {
    enum CodingKeys: String, CodingKey {
        case values
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
        self.init(in: values)
    }
}

extension Rules.RequireLocale: Decodable {
    enum CodingKeys: String, CodingKey {
        case values
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
        self.init(in: values)
    }
}

extension Rules.RequireLocalizationState: Decodable {
    enum CodingKeys: String, CodingKey {
        case values
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
        self.init(in: values)
    }
}

extension Rules.RejectLocalizationState: Decodable {
    enum CodingKeys: String, CodingKey {
        case values
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
        self.init(in: values)
    }
}

extension Rules.RequireComment: Decodable {
    public init(from decoder: any Decoder) throws {
        self.init()
    }
}

extension Rules.RequireMatchingPlaceholders: Decodable {
    public init(from decoder: any Decoder) throws {
        self.init()
    }
}

extension Rules.RejectEmptyValues: Decodable {
    public init(from decoder: any Decoder) throws {
        self.init()
    }
}

extension Rules.RejectPatterns: Decodable {
    enum CodingKeys: String, CodingKey {
        case values
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
        self.init(patterns: values)
    }
}

extension Rules.RequirePositionalPlaceholders: Decodable {
    enum CodingKeys: String, CodingKey {
        case applyToAll
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let applyToAll = try container.decodeIfPresent(Bool.self, forKey: .applyToAll) ?? false
        self.init(applyToAll: applyToAll)
    }
}

extension Rules.RequireObjectPlaceholders: Decodable {
    public init(from decoder: any Decoder) throws {
        self.init()
    }
}
