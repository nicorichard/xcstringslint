extension Rules {
    public struct RequireLocale: Rule {
        let locales: [String]
        public let name = "require-locale"

        public init(locales: [String]) {
            self.locales = locales
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            let missinglocales = locales.filter { language in
                value.localizations?[language] == nil
            }

            let message = String(
                localized: "is missing translations for locales: \(missinglocales.joined(separator: ", "))",
                bundle: .module
            )

            return fail(message: message)
        }
    }
}

extension Rules.RequireLocale {
    public init(locales: String...) {
        self.locales = locales
    }
}
