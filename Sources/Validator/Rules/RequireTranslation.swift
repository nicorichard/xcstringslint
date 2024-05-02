extension Rules {
    // TODO: include or disclude "needs_review"
    public static func requireTranslation(languages: String...) -> Rule {
        Rule { key, value in
            let missingLanguages = languages.filter { language in
                value.localizations?[language] == nil
            }

            let missingLanguageList = missingLanguages.joined(separator: ", ")

            return [
                RuleValidation(
                    message: String(localized: "is missing translations for languages keys: \(missingLanguageList)", bundle: .module)
                )
            ]
        }
    }
}
