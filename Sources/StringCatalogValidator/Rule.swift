import Foundation
import StringCatalogDecodable

public protocol Rule {
    static var name: String { get }
    var severity: Severity { get }
    typealias Entry = StringCatalog.Entry
    typealias Failure = Validator.Reason
    func validate(key: String, value: Entry) -> [Failure]
}

extension Rule {
    func fail(message: String) -> [Failure] {
        [
            Validator.Reason(rule: self, message: message)
        ]
    }

    func fail(message: String) -> Failure {
        Validator.Reason(rule: self, message: message)
    }

    var success: [Failure] {
        []
    }
}
