import StringCatalogDecodable

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

    func shouldIgnore(key: String, rule: String, value: StringCatalog.Entry) -> Bool {
        ignores.reduce(false) { acc, ignore in
            acc || ignore.ignore(key: key, rule: rule, value: value)
        }
    }

    public func validate(catalog: StringCatalog) -> [Validation] {
        catalog
            .strings
            .sorted { $0.key < $1.key }
            .reduce([Validation]()) { acc, current in
                let (key, value) = current

                let results: [Reason] = rules.flatMap { rule -> [Reason] in
                    if shouldIgnore(key: key, rule: type(of: rule).name, value: value) {
                        return []
                    }

                    return rule.validate(key: key, value: value)
                }

                if results.isEmpty {
                    return acc
                }

                return acc + [Validation(key: key, validations: results)]
            }
    }
}

extension Validator {
    public struct Validation {
        public let key: String
        public let validations: [Reason]
    }

    public struct Reason: Equatable {
        public let name: String
        public let description: String
        public let severity: Severity
        public let message: String
    }
}
