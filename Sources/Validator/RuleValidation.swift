import Foundation

public protocol Rule {
    func validate(key: String, value: Catalog.CatalogString) -> [RuleValidation]
}

public struct RuleValidation {
    public let message: String
}
