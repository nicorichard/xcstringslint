extension Rules {
    public static func requireLocale(locales: [String]) -> Rule {
        Rule { key, value in
            let missinglocales = locales.filter { language in
                value.localizations?[language] == nil
            }

            let missingLocaleList = missinglocales.joined(separator: ", ")

            return [
                RuleValidation(
                    message: String(localized: "is missing translations for locales: \(missingLocaleList)", bundle: .module)
                )
            ]
        }
    }
    public static func requireLocale(locales: String...) -> Rule {
        requireLocale(locales: locales)
    }
}
