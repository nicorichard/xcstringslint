struct Config: Decodable {
    let rules: [String: Rule]

    struct Rule: Decodable {
        let values: [String]
        let severity: Severity

        enum Severity: String, Decodable {
            case warning
            case error
        }

        enum CodingKeys: String, CodingKey {
            case value
            case values
            case severity
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let value = try? container.decodeIfPresent(String.self, forKey: .value) {
                values = [value]
            } else {
                values = try container.decode([String].self, forKey: .values)
            }

            if let severity = try? container.decodeIfPresent(String.self, forKey: .severity) {
                guard let severity = Severity(rawValue: severity) else {
                    throw DecodingError.typeMismatch(
                        Severity.self,
                        .init(codingPath: container.codingPath, debugDescription: "Invalid severity value")
                    )
                }
                self.severity = severity
            } else {
                severity = .error
            }
        }
    }
}
