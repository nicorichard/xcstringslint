import StringCatalogDecodable

public struct ValidationResult {
    public let key: String
    public let validations: [ValidationFailed]
}

public struct Validator {

    let rules: [RuleProtocol]
    let ignores: [Ignore]

    public init(rules: [RuleProtocol]) {
        self.rules = rules
        self.ignores = []
    }

    public init(rules: [RuleProtocol], ignores: Ignore...) {
        self.rules = rules
        self.ignores = ignores
    }

    public func validate(catalog: StringCatalog) -> [ValidationResult] {
        catalog
            .strings
            .sorted { $0.key < $1.key }
            .reduce([ValidationResult]()) { acc, current in
                let (key, value) = current

                let results: [ValidationFailed] = rules.flatMap { rule in
                    let ignore = ignores
                        .reduce(false, { acc, ignore in
                            acc || ignore.ignore(key: key, rule: rule.name, value: value)
                        })

                    if ignore {
                        return [ValidationFailed]()
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
