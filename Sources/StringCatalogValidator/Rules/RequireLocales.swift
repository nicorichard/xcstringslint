extension Rules {
    public struct RequireLocale: RuleConvertible {
        let locales: [String]

        public init(locales: [String]) {
            self.locales = locales
        }

        public var rule: some RuleProtocol {
            Rule("require-locale") { key, value in
                let missinglocales = locales.filter { language in
                    value.localizations?[language] == nil
                }

                return String(
                    localized: "is missing translations for locales: \(missinglocales.joined(separator: ", "))",
                    bundle: .module
                )
            }
        }
    }
}

extension Rules.RequireLocale {
    public init(locales: String...) {
        self.locales = locales
    }
}
