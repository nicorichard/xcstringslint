import Foundation
import ArgumentParser

struct CatalogLoader {
    func loadCatalog(from path: String) throws -> Catalog {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: path) else {
            throw ValidationError("Could not find xcstrings catalog at path: \(path)")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))

        return try loadCatalog(from: data)
    }

    func loadCatalog(from data: Data) throws -> Catalog {
        let decoder = JSONDecoder()

        return try decoder.decode(Catalog.self, from: data)
    }
}
