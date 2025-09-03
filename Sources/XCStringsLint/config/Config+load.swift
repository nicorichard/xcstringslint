import Foundation
import ArgumentParser
import Yams

extension Config {
    static func load(from path: String) throws -> Config {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("No xcstringslint config file could be found at path: \(path)")
        }

        let data: Data
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            throw ValidationError("Failed to read config file at \(path): \(error.localizedDescription)")
        }

        let decoder = YAMLDecoder()
        
        do {
            return try decoder.decode(Config.self, from: data)
        } catch {
            throw ValidationError("Invalid config file format at \(path): \(error.localizedDescription)")
        }
    }
}
