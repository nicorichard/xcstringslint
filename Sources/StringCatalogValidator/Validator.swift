import StringCatalogDecodable

public struct ValidationResult {
    public let key: String
    public let validations: [RuleValidation]
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

    public func validate(catalog: StringCatalog) -> [ValidationResult] {
        catalog.strings.reduce([ValidationResult]()) { acc, current in
            let (key, value) = current

            let results: [RuleValidation] = rules.flatMap { rule in
                let ignore = ignores
                    .reduce(false, { acc, ignore in
                        acc || ignore.ignore(key: key, rule: rule.name, value: value)
                    })

                if ignore {
                    return [RuleValidation]()
                }

                return rule.validate(key: key, value: value)
            }

            if results.isEmpty {
                return acc
            }

            return acc + [ValidationResult(key: key, validations: results)]
        }
    }
}
