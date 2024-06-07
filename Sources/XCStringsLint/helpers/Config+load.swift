import Foundation
import ArgumentParser
import Yams

extension Config {
    static func load(from path: String) throws -> Config {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("No xcstringslint config file could be found at path: \(path)")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))

        let decoder = YAMLDecoder()
        return try decoder.decode(Config.self, from: data)
    }
}
