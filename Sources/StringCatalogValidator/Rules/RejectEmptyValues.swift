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
                    if Self.isEmpty(stringUnit.value) {
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

extension Rules.RejectEmptyValues {
    /// Check if a string value would be considered empty by this rule
    public static func isEmpty(_ value: String) -> Bool {
        return value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Get detailed analysis of why a string is considered empty
    public static func analyzeEmptyString(_ value: String) -> EmptyStringAnalysis {
        if value.isEmpty {
            return .completelyEmpty
        }
        
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            let whitespaceTypes = analyzeWhitespaceTypes(in: value)
            return .whitespaceOnly(types: whitespaceTypes)
        }
        
        return .notEmpty
    }
    
    private static func analyzeWhitespaceTypes(in string: String) -> [WhitespaceType] {
        var types: Set<WhitespaceType> = []
        
        for char in string {
            switch char {
            case " ":
                types.insert(.spaces)
            case "\t":
                types.insert(.tabs)
            case "\n":
                types.insert(.newlines)
            case "\r":
                types.insert(.carriageReturns)
            default:
                if char.isWhitespace {
                    types.insert(.otherUnicode)
                }
            }
        }
        
        return Array(types).sorted { $0.rawValue < $1.rawValue }
    }
}

// MARK: - Supporting Types

public enum EmptyStringAnalysis {
    case completelyEmpty
    case whitespaceOnly(types: [WhitespaceType])
    case notEmpty
}

public enum WhitespaceType: String, CaseIterable {
    case spaces = "spaces"
    case tabs = "tabs" 
    case newlines = "newlines"
    case carriageReturns = "carriage_returns"
    case otherUnicode = "other_unicode"
}
