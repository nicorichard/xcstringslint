import Foundation

public protocol RuleProtocol {
    func validate(key: String, value: Catalog.CatalogString) -> [RuleValidation]
}

public struct Rule: RuleProtocol {
    let validateFn: (_ key: String, _ value: Catalog.CatalogString) -> [RuleValidation]

    public init(validate: @escaping (_: String, _: Catalog.CatalogString) -> [RuleValidation]) {
        self.validateFn = validate
    }

    public func validate(key: String, value: Catalog.CatalogString) -> [RuleValidation] {
        validateFn(key, value)
    }
}

extension Rule {
    public init(validate: @escaping (_: String, _: Catalog.CatalogString) -> String) {
        self.validateFn = { key, value in
            [RuleValidation(message: validate(key, value))]
        }
    }
}

public struct RuleValidation {
    public let message: String
}
