import Foundation
import StringCatalogDecodable

extension Rules {
    /// Validates that string keys have developer comments
    ///
    /// This rule helps ensure that all localized strings include
    /// helpful context for translators through developer comments.
    /// Comments provide crucial context about string usage, tone,
    /// and any special formatting requirements.
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   require-comment:
    ///     severity: warning
    /// ```
    ///
    /// # Examples
    /// 
    /// **Valid:**
    /// ```json
    /// {
    ///   "comment": "Button label for saving user preferences",
    ///   "localizations": {
    ///     "en": { "stringUnit": { "state": "translated", "value": "Save" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid:**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "state": "translated", "value": "Save" } }
    ///   }
    /// }
    /// ```
    public struct RequireComment: Rule {
        public var severity: Severity = .warning
        public static let name = "require-comment"
        public static let description = "Requires that each string key includes a developer comment"
        
        public init() {}
        
        public func validate(key: String, value: Entry) -> [Failure] {
            // Skip validation for keys marked as "Don't Translate"
            if value.shouldTranslate == false {
                return success
            }
            
            // Check if comment exists and is not empty
            guard let comment = value.comment?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !comment.isEmpty else {
                return fail(message: "missing developer comment - add context for translators")
            }
            
            // Check for meaningful comments (not just placeholder text)
            let lowercaseComment = comment.lowercased()
            let meaninglessComments = ["comment", "todo", "fix", "update", "change"]
            
            if meaninglessComments.contains(where: { lowercaseComment == $0 || lowercaseComment.hasPrefix($0 + " ") }) {
                return fail(message: "comment appears to be a placeholder - provide meaningful context for translators")
            }
            
            return success
        }
    }
}
