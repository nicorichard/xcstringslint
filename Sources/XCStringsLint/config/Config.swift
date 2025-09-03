import StringCatalogValidator

struct Config: Decodable {
    let rules: [AnyRule]

    struct AnyRule: Decodable {
        let rule: Rule

        enum CodingKeys: String, CodingKey {
            case name
            case severity
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let ruleName = try container.decode(String.self, forKey: .name)

            guard let ruleEntry = ConfigurableRule.init(name: ruleName) else {
                throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Unknown rule: \(ruleName)")
            }

            var rule = try ruleEntry.type.init(from: decoder)
            if let severity = try container.decodeIfPresent(Severity.self, forKey: .severity) {
                rule.severity = switch(severity) {
                    case .error: .error
                    case .warning: .warning
                }
            }
            self.rule = rule
        }

        enum Severity: String, Decodable {
            case error
            case warning
        }
    }
}
