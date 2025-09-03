import Foundation
import StringCatalogDecodable

extension Rules {
    /// Rejects strings that contain empty or whitespace-only values
    ///
    /// This rule helps catch incomplete translations and ensures
    /// all strings have meaningful content. Empty values can cause
    /// UI issues where labels disappear or buttons have no text.
    /// Whitespace-only values are often indicators of incomplete
    /// localization work.
    ///
    /// # What this rule detects:
    /// - Completely empty string values (`""`)
    /// - Whitespace-only values (`"   "`, `"\n\t"`)
    /// - Strings containing only Unicode whitespace characters
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   reject-empty-values:
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid:**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Save Changes" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (empty value):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (whitespace only):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "   \n\t  " } }
    ///   }
    /// }
    /// ```
    public struct RejectEmptyValues: Rule {
        public var severity: Severity = .error
        public static let name = "reject-empty-values"
        public static let description = "Rejects translation values that are empty or whitespace-only"
        
        public init() {}
        
        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations else {
                return success
            }
            
            var failures: [String] = []
            
            for (locale, localization) in localizations {
                for stringUnit in localization.stringUnits {
                    if stringUnit.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if stringUnit.value.isEmpty {
                            failures.append("empty value in '\(locale)' locale")
                        } else {
                            failures.append("whitespace-only value in '\(locale)' locale")
                        }
                    }
                }
            }
            
            return failures.map { fail(message: $0) }
        }
    }
}
