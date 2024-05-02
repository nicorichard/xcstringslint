import Foundation
import StringCatalogDecodable

public protocol RuleProtocol {
    func validate(key: String, value: StringCatalog.Entry) -> [RuleValidation]
}

public struct Rule: RuleProtocol {
    let validateFn: (_ key: String, _ value: StringCatalog.Entry) -> [RuleValidation]

    public init(validate: @escaping (_: String, _: StringCatalog.Entry) -> [RuleValidation]) {
        self.validateFn = validate
    }

    public func validate(key: String, value: StringCatalog.Entry) -> [RuleValidation] {
        validateFn(key, value)
    }
}

extension Rule {
    public init(validate: @escaping (_: String, _: StringCatalog.Entry) -> String) {
        self.validateFn = { key, value in
            [RuleValidation(message: validate(key, value))]
        }
    }
}

public struct RuleValidation {
    public let message: String
}
