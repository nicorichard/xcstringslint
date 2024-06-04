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

        let data = try Data(contentsOf: URL(fileURLWithPath: path))

        return try load(from: data)
    }

    static func load(from data: Data) throws -> StringCatalog {
        let decoder = JSONDecoder()

        return try decoder.decode(StringCatalog.self, from: data)
    }
}
