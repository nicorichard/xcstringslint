extension Rules {
    public static func requireLocale(locales: [String]) -> Rule {
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
    public static func requireLocale(locales: String...) -> Rule {
        requireLocale(locales: locales)
    }
}
