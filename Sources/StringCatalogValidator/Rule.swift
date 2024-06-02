import Foundation
import StringCatalogDecodable

public protocol Rule {
    static var name: String { get }
    typealias Entry = StringCatalog.Entry
    typealias Reason = Validator.Reason
    func validate(key: String, value: Entry) -> [Reason]
}

extension Rule {
    func fail(message: String) -> [Reason] {
        [
            Validator.Reason(rule: Self.name, message: message)
        ]
    }

    func fail(message: String) -> Reason {
        Validator.Reason(rule: Self.name, message: message)
    }

    var success: [Reason] {
        []
    }
}
