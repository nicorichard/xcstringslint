public struct Config: Decodable {
    let rules: [Rule]

    public struct Rule: Decodable {
        let name: String
        let values: [String]
        let severity: Severity

        public enum Severity: String, CaseIterable, Decodable {
            case warning
            case error
        }

        enum CodingKeys: String, CaseIterable, CodingKey {
            case name
            case value
            case values
            case severity
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            name = try container.decode(String.self, forKey: .name)

            if let value = try? container.decodeIfPresent(String.self, forKey: .value) {
                values = [value]
            } else if let values = try? container.decodeIfPresent([String].self, forKey: .values) {
                self.values = values
            } else {
                values = []
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
                severity = .warning
            }
        }
        
        public init(name: String, values: [String], severity: Severity) {
            self.name = name
            self.values = values
            self.severity = severity
        }
    }
}
