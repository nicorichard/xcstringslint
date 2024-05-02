import Foundation
import Validator
import StringCatalogDecodable
import ArgumentParser

struct StringCatalogLoader {
    func loadCatalog(from path: String) throws -> StringCatalog {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("Could not find xcstrings catalog at path: \(path)")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))

        return try loadCatalog(from: data)
    }

    func loadCatalog(from data: Data) throws -> StringCatalog {
        let decoder = JSONDecoder()

        return try decoder.decode(StringCatalog.self, from: data)
    }
}
