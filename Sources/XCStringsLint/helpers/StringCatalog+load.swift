import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

extension StringCatalog {
    static func load(from path: String) throws -> StringCatalog {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("Could not find xcstrings catalog at path: \(path)")
        }

        let data: Data
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            throw ValidationError("Failed to read xcstrings file at \(path): \(error.localizedDescription)")
        }

        return try load(from: data)
    }

    static func load(from data: Data) throws -> StringCatalog {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(StringCatalog.self, from: data)
        } catch {
            throw ValidationError("Invalid xcstrings file format: \(error.localizedDescription)")
        }
    }
}
