import Foundation
import StringCatalogDecodable

public struct Rule: RuleProtocol {
    public let name: String
    let validateFn: (_ key: String, _ value: Entry) -> [ValidationFailed]

    public init(_ name: String, validate: @escaping (_: String, _: StringCatalog.Entry) -> [ValidationFailed]) {
        self.name = name
        self.validateFn = validate
    }

    public init(_ name: String, renaming rule: RuleProtocol) {
        self.name = name
        self.validateFn = rule.validate
    }

    public func validate(key: String, value: Entry) -> [ValidationFailed] {
        validateFn(key, value)
    }
}

extension Rule {
    public init(_ name: String, validate: @escaping (_: String, _: Entry) -> String?) {
        self.name = name
        self.validateFn = { key, value in
            guard let message = validate(key, value) else { return [] }
            return [
                ValidationFailed(
                    key: key,
                    value: value,
                    rule: name,
                    message: message
                )
            ]
        }
    }
}
