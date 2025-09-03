import StringCatalogValidator
import ArgumentParser

extension Config {
    func toDomain() throws -> [StringCatalogValidator.Rule] {
        try rules.compactMap { rule -> StringCatalogValidator.Rule? in
            let ruleName = rule.name
            let domainRule = registry
                .first(where: { $0.name == ruleName })
                .map {
                    var domainRule = $0.init(values: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                }

            if domainRule == nil {
                throw ValidationError("Unknown rule: \(ruleName)")
            }

            return domainRule
        }
    }
}


extension Config.Rule.Severity {
    func toDomain() -> Severity {
        switch self {
            case .error: .error
            case .warning: .warning
        }
    }
}
