import Foundation
import StringCatalogDecodable

extension Rules {
    /// Validates that placeholders are consistent across all locales
    ///
    /// This rule ensures that placeholder patterns like %@, %d, %1$@
    /// are consistent across all translations, preventing runtime crashes
    /// and formatting issues. Mismatched placeholders are a common source
    /// of localization bugs that can cause app crashes or display issues.
    ///
    /// # Supported Placeholder Patterns
    /// - `%@` - Object placeholder
    /// - `%d`, `%i` - Integer placeholders  
    /// - `%f`, `%g` - Floating point placeholders
    /// - `%1$@`, `%2$d` - Positional placeholders
    /// - `%s` - String placeholder
    /// - `%%` - Literal percent sign
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   require-matching-placeholders:
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid (consistent placeholders):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello %@, you have %d messages" } },
    ///     "es": { "stringUnit": { "value": "Hola %@, tienes %d mensajes" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (missing placeholder in Spanish):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello %@, you have %d messages" } },
    ///     "es": { "stringUnit": { "value": "Hola %@, tienes mensajes" } }
    ///   }
    /// }
    /// ```
    public struct RequireMatchingPlaceholders: Rule {
        public var severity: Severity = .error
        public static let name = "require-matching-placeholders"
        public static let description = "Ensures placeholder consistency across all locales"
        
        public init() {}
        
        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations, localizations.count > 1 else {
                return success
            }
            
            // Get reference locale (usually the first one, often base language)
            let sortedLocalizations = localizations.sorted { $0.key < $1.key }
            let (referenceLocale, referenceLocalization) = sortedLocalizations.first!
            
            guard let referenceStringUnit = referenceLocalization.stringUnits.first else {
                return success
            }
            
            let referencePlaceholders = extractPlaceholders(from: referenceStringUnit.value)
            var failures: [String] = []
            
            // Compare all other locales against the reference
            for (locale, localization) in sortedLocalizations.dropFirst() {
                for stringUnit in localization.stringUnits {
                    let localePlaceholders = extractPlaceholders(from: stringUnit.value)
                    
                    if Set(referencePlaceholders) != Set(localePlaceholders) {
                        let missing = Set(referencePlaceholders).subtracting(Set(localePlaceholders))
                        let extra = Set(localePlaceholders).subtracting(Set(referencePlaceholders))
                        
                        var message = "placeholder mismatch in '\(locale)' (reference: '\(referenceLocale)')"
                        
                        if !missing.isEmpty {
                            message += " - missing: \(missing.sorted().joined(separator: ", "))"
                        }
                        if !extra.isEmpty {
                            message += " - unexpected: \(extra.sorted().joined(separator: ", "))"
                        }
                        
                        failures.append(message)
                    }
                }
            }
            
            return failures.map { fail(message: $0) }
        }
        
        /// Extracts placeholder patterns from a string using regex
        private func extractPlaceholders(from string: String) -> [String] {
            // Regex pattern to match various printf-style format specifiers
            let pattern = #"%(?:\d+\$)?[-#+ 0]*\*?(?:\d+|\*)?(?:\.(?:\d+|\*))?[hlL]?[@dDuUxXoOfFeEgGaAcspn%]"#
            
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                return []
            }
            
            let range = NSRange(string.startIndex..<string.endIndex, in: string)
            let matches = regex.matches(in: string, options: [], range: range)
            
            return matches.compactMap { match in
                guard let range = Range(match.range, in: string) else { return nil }
                return String(string[range])
            }.sorted()
        }
    }
}

extension Rules.RequireMatchingPlaceholders {
    /// Validates a specific string for placeholder consistency
    public static func validateString(_ string: String, against reference: String) -> [String] {
        let validator = Rules.RequireMatchingPlaceholders()
        let referencePlaceholders = validator.extractPlaceholders(from: reference)
        let stringPlaceholders = validator.extractPlaceholders(from: string)
        
        var issues: [String] = []
        
        let missing = Set(referencePlaceholders).subtracting(Set(stringPlaceholders))
        let extra = Set(stringPlaceholders).subtracting(Set(referencePlaceholders))
        
        if !missing.isEmpty {
            issues.append("Missing placeholders: \(missing.sorted().joined(separator: ", "))")
        }
        
        if !extra.isEmpty {
            issues.append("Unexpected placeholders: \(extra.sorted().joined(separator: ", "))")
        }
        
        return issues
    }
}
