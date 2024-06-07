struct Config: Decodable {
    let rules: [String: Rule]

    struct Rule: Decodable {
        let values: [String]

        enum CodingKeys: String, CodingKey {
            case value
            case values
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let value = try? container.decodeIfPresent(String.self, forKey: .value) {
                values = [value]
            } else {
                values = try container.decode([String].self, forKey: .values)
            }
        }
    }
}
