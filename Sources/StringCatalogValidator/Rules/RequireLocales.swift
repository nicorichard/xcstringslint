extension Rules {

    // MARK: - RequireLocale

    /// Requires that each key contains localizations for the provided locale values
    ///
    /// This rule ensures that all specified locales have translations present
    /// in the string catalog. Essential for maintaining complete localization
    /// coverage across your app's supported languages and regions.
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   require-locale:
    ///     values: ["en", "es", "fr"]  # List of required locale codes
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid (all required locales present):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello" } },
    ///     "es": { "stringUnit": { "value": "Hola" } },
    ///     "fr": { "stringUnit": { "value": "Bonjour" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (missing French translation):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello" } },
    ///     "es": { "stringUnit": { "value": "Hola" } }
    ///   }
    /// }
    /// ```
    public struct RequireLocale: Rule {
        let locales: [String]
        public var severity: Severity = .error
        public static let name = "require-locale"
        public static let description = "Requires that each key contains localizations for the provided locale values"

        public init(in locales: [String]) {
            self.locales = locales
        }

        public func validate(key: String, value: Entry) -> [Failure] {
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

// MARK: - Extensions

extension Rules.RequireLocale {
    public init(in locales: String...) {
        self.locales = locales
    }

    public init(locale: String) {
        self.locales = [locale]
    }
}
