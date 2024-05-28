import Foundation
import StringCatalogValidator

class EntryDecoder {
    static let decoder = JSONDecoder()

    static func entry(from json: String) throws -> Rule.Entry {
        enum Error: Swift.Error {
            case invalidJSON
        }

        guard let data = json.data(using: .utf8) else { throw Error.invalidJSON }

        return try decoder.decode(Rule.Entry.self, from: data)
    }
}
