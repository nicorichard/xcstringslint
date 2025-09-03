import Foundation
import StringCatalogDecodable

extension Rules {

    // MARK: - RequireExtractionState

    /// Requires that each key's extraction state matches one of the provided values
    ///
    /// This rule ensures that string keys have the expected extraction state,
    /// helping maintain consistency in how strings are extracted and managed.
    /// Extraction states indicate how a string was added to the catalog:
    /// automatically extracted from code, manually added, or extracted with
    /// an existing value.
    ///
    /// # Known Extraction States:
    /// - `automatic` - Extracted automatically from code
    /// - `manual` - Added manually to the catalog
    /// - `extracted_with_value` - Extracted with existing translation
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   require-extraction-state:
    ///     value: "automatic"  # or values: ["automatic", "manual"]
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid (automatic extraction):**
    /// ```json
    /// {
    ///   "extractionState": "automatic",
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello World" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Valid (no extraction state, defaults to automatic):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello World" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (manual when requiring automatic):**
    /// ```json
    /// {
    ///   "extractionState": "manual",
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello World" } }
    ///   }
    /// }
    /// ```
    public struct RequireExtractionState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "require-extraction-state"
        public static let description = "Requires that each key's extraction state matches one of the provided values"

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            let actualState = value.extractionState ?? Rules.defaultExtractionState

            if (states.contains(actualState)) { return success }

            let message = String(localized: "should not have extraction state `\(actualState)`", bundle: .module)

            return fail(message: message)
        }
    }

    // MARK: - RejectExtractionState

    /// Rejects entries if their extraction state matches any of the provided values
    ///
    /// This rule prevents strings with specific extraction states from being
    /// accepted, helping enforce extraction policies. For example, you might
    /// want to reject manually added strings in favor of automatic extraction
    /// to ensure all strings come from code.
    ///
    /// # Known Extraction States:
    /// - `automatic` - Extracted automatically from code
    /// - `manual` - Added manually to the catalog
    /// - `extracted_with_value` - Extracted with existing translation
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   reject-extraction-state:
    ///     values: ["manual", "extracted_with_value"]
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid (automatic extraction):**
    /// ```json
    /// {
    ///   "extractionState": "automatic",
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello World" } }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (manual extraction when rejected):**
    /// ```json
    /// {
    ///   "extractionState": "manual", 
    ///   "localizations": {
    ///     "en": { "stringUnit": { "value": "Hello World" } }
    ///   }
    /// }
    /// ```
    public struct RejectExtractionState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "reject-extraction-state"
        public static let description = "Rejects entries if their extraction state matches any of the provided values"

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            let state = value.extractionState ?? Rules.defaultExtractionState
            if (!states.contains(state)) { return success }

            let message = String(localized: "should not have state \(state)", bundle: .module)

            return fail(message: message)
        }
    }
}

// MARK: - Extensions

extension Rules {
    fileprivate static var defaultExtractionState: String {
        ExtractionState.automatic.rawValue
    }
}

extension Rules.RequireExtractionState {
    public init(in states: String...) {
        self.states = states
    }

    public init(state: String?) {
        self.states = [state ?? Rules.defaultExtractionState]
    }
}

extension Rules.RejectExtractionState {
    public init(in states: String...) {
        self.states = states
    }

    public init(state: String?) {
        self.states = [state ?? Rules.defaultExtractionState]
    }
}
