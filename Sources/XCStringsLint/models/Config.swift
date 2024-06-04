import Foundation
import ArgumentParser
import Yams

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

extension Config {
    static func load(from path: String) throws -> Config {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("Could not find xcstrings catalog at path: \(path)")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))

        let decoder = YAMLDecoder()
        return try decoder.decode(Config.self, from: data)
    }
}
