extension Rules {
    public struct RequireLocale: Rule {
        let locales: [String]
        public let name = "require-locale"

        public init(locales: [String]) {
            self.locales = locales
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            let missingLocales = locales.filter { language in
                value.localizations?[language] == nil
            }

            if missingLocales.isEmpty {
                return success
            }

            let message = String(
                localized: "missing translation for \(missingLocales.count) locale: \(missingLocales.joined(separator: ", "))",
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
