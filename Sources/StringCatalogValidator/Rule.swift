import Foundation
import StringCatalogDecodable

public protocol Rule {
    typealias Entry = StringCatalog.Entry
    typealias Failure = Validator.Reason

    static var name: String { get }
    static var description: String { get }

    var severity: Severity { get set }
    func validate(key: String, value: Entry) -> [Failure]
}

extension Rule {
    func fail(message: String) -> [Failure] {
        [fail(message: message)]
    }

    func fail(message: String) -> Failure {
        Validator.Reason(
            name: Self.name,
            description: Self.description,
            severity: severity,
            message: message
        )
    }

    var success: [Failure] {
        []
    }
}
