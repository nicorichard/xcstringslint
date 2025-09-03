import Foundation
import StringCatalogDecodable

extension Rules {
    /// Validates that strings don't contain forbidden patterns or words
    ///
    /// This rule helps enforce content guidelines by preventing
    /// specific words, phrases, or patterns from appearing in
    /// translations. Useful for maintaining brand voice and
    /// avoiding problematic content.
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   reject-patterns:
    ///     values: ["TODO", "FIXME", "placeholder"]
    ///     severity: error
    /// ```
    public struct RejectPatterns: Rule {
        let patterns: [String]
        let caseSensitive: Bool
        public var severity: Severity = .error
        public static let name = "reject-patterns"
        public static let description = "Ensures strings don't contain forbidden words or patterns"
        
        public init(patterns: [String], caseSensitive: Bool = false) {
            self.patterns = patterns
            self.caseSensitive = caseSensitive
        }
        
        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations else {
                return success
            }
            
            var failures: [String] = []
            
            for (locale, localization) in localizations {
                for stringUnit in localization.stringUnits {
                    let text = caseSensitive ? stringUnit.value : stringUnit.value.lowercased()
                    
                    for pattern in patterns {
                        let searchPattern = caseSensitive ? pattern : pattern.lowercased()
                        
                        if text.contains(searchPattern) {
                            failures.append("'\(locale)' translation contains forbidden pattern '\(pattern)'")
                        }
                    }
                }
            }
            
            return failures.map { fail(message: $0) }
        }
    }
}
