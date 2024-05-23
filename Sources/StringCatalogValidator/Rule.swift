import Foundation
import StringCatalogDecodable

public protocol Rule {
    var name: String { get }
    typealias Entry = StringCatalog.Entry
    func validate(key: String, value: Entry) -> [ValidationFailed]
}

extension Rule {
    func fail(message: String) -> [ValidationFailed] {
        [
            ValidationFailed(rule: name, message: message)
        ]
    }

    func fail(message: String) -> ValidationFailed {
        ValidationFailed(rule: name, message: message)
    }

    var success: [ValidationFailed] {
        []
    }
}
