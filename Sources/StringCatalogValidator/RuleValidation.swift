import Foundation
import StringCatalogDecodable

public protocol RuleProtocol {
    var name: String { get }
    func validate(key: String, value: StringCatalog.Entry) -> [RuleValidation]
}

public struct Rule: RuleProtocol {
    public let name: String
    let validateFn: (_ key: String, _ value: StringCatalog.Entry) -> [RuleValidation]

    public init(_ name: String, validate: @escaping (_: String, _: StringCatalog.Entry) -> [RuleValidation]) {
        self.name = name
        self.validateFn = validate
    }

    public init(_ name: String, renaming rule: RuleProtocol) {
        self.name = name
        self.validateFn = rule.validate
    }

    public func validate(key: String, value: StringCatalog.Entry) -> [RuleValidation] {
        validateFn(key, value)
    }
}

extension Rule {
    public init(_ name: String, validate: @escaping (_: String, _: StringCatalog.Entry) -> String?) {
        self.name = name
        self.validateFn = { key, value in
            guard let message = validate(key, value) else { return [] }
            return [
                RuleValidation(rule: name, message: message)
            ]
        }
    }
}

public struct RuleValidation {
    public let rule: String
    public let message: String
}
