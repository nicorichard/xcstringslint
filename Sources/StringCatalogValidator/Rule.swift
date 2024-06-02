import Foundation
import StringCatalogDecodable

public protocol Rule {
    var name: String { get }
    typealias Entry = StringCatalog.Entry
    typealias Reason = Validator.Reason
    func validate(key: String, value: Entry) -> [Reason]
}

extension Rule {
    func fail(message: String) -> [Reason] {
        [
            Validator.Reason(rule: name, message: message)
        ]
    }

    func fail(message: String) -> Reason {
        Validator.Reason(rule: name, message: message)
    }

    var success: [Reason] {
        []
    }
}
