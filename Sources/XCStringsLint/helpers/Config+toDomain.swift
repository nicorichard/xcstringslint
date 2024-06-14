import StringCatalogValidator
import ArgumentParser

extension Config {
    func toDomain() throws -> [StringCatalogValidator.Rule] {
        try rules.compactMap { (ruleName, rule) -> StringCatalogValidator.Rule? in
            switch ruleName {
                case Rules.RequireExtractionState.name:
                    var domainRule = Rules.RequireExtractionState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RejectExtractionState.name:
                    var domainRule = Rules.RejectExtractionState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RequireLocale.name:
                    var domainRule = Rules.RequireLocale(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RequireLocalizationState.name:
                    var domainRule = Rules.RequireLocalizationState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                case Rules.RejectLocalizationState.name:
                    var domainRule = Rules.RejectLocalizationState(in: rule.values)
                    domainRule.severity = rule.severity.toDomain()
                    return domainRule
                default:
                    throw ValidationError("Unknown rule: \(ruleName)")
            }
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
