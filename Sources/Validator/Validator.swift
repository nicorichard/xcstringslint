public struct ValidationResult {
    public let key: String
    public let validation: RuleValidation
}

public struct Validator {

    let rules: [Rule]
    let ignores: [Ignore]

    public init(rules: [Rule]) {
        self.rules = rules
        self.ignores = []
    }

    public init(rules: [Rule], ignores: Ignore...) {
        self.rules = rules
        self.ignores = ignores
    }

    public func validate(catalog: Catalog) -> [ValidationResult] {
        rules.flatMap { rule in
            catalog.strings.reduce([ValidationResult]()) { acc, current in
                let (key, value) = current

                let ignore = ignores
                    .reduce(false, { acc, ignore in acc || ignore.ignore(key: key, value: value) })

                if ignore {
                    return acc
                }

                let results = rule.validate(key: key, value: value)
                    .map { ValidationResult(key: key, validation: $0) }

                return acc + results
            }
        }
    }
}
