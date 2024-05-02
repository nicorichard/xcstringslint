import Foundation

public struct RequireManual: Rule {
    public init() {}
    
    public func validate(key: String, value: Catalog.CatalogString) -> [RuleValidation] {

        guard (value.extractionState != "manual") else { return [] }

        return [
            RuleValidation(
                message: String(localized: "is not marked as manual", bundle: .module)
            )
        ]
    }
}
