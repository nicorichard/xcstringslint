public struct ValidationResult {
    public let key: String
    public let validation: RuleValidation
}

public struct Validator {
    public init() {}

    public func validate(catalog: Catalog, with rules: [Rule]) -> [ValidationResult] {
        rules.flatMap { rule in
            catalog.strings.reduce([ValidationResult]()) { acc, current in
                let results = rule.validate(key: current.key, value: current.value).map { ValidationResult(key: current.key, validation: $0) }
                return acc + results
            }
        }
    }
}
