import Foundation
import StringCatalogDecodable

extension Rules {
    /// Requires that each localization's state matches one of the provided values
    ///
    /// This rule ensures that translations are in the expected state before
    /// release. Localization states indicate the quality and completeness
    /// of translations, helping maintain high-quality localized content.
    ///
    /// # Known Localization States:
    /// - `translated` - Completed and reviewed translation
    /// - `needs_review` - Translation needs review
    /// - `stale` - Translation may be outdated
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   require-localization-state:
    ///     value: "translated"  # or values: ["translated", "needs_review"]
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid (translated state):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { 
    ///       "stringUnit": { 
    ///         "state": "translated", 
    ///         "value": "Hello World" 
    ///       } 
    ///     }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (needs review state when requiring translated):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { 
    ///       "stringUnit": { 
    ///         "state": "needs_review", 
    ///         "value": "Hello World" 
    ///       } 
    ///     }
    ///   }
    /// }
    /// ```
    public struct RequireLocalizationState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "require-localization-state"
        public static let description = "Requires that each localization's state matches one of the provided values"

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations else {
                if states.contains(Rules.emptyLocalizationState) {
                    return success
                }

                return fail(
                    message: String(localized: "no translation state found", bundle: .module)
                )
            }

            return localizations.flatMap { key, value in
                value.stringUnits.compactMap {
                    if !states.contains($0.state) {
                        if states.count == 1 {
                            return String(localized: "found state `\($0.state)`, expected `\(states[0])`", bundle: .module)
                        } else {
                            return String(localized: "found state `\($0.state)`, expected one of: \(states.map { "`\($0)`" }.joined(separator: ", "))", bundle: .module)
                        }
                    }
                    return nil
                }
            }.map(fail)
        }
    }
}

extension Rules {
    /// Rejects localizations that have states matching the provided values
    ///
    /// This rule prevents translations from being released when they are
    /// in undesirable states. Use this to block incomplete or problematic
    /// translations from reaching production.
    ///
    /// # Known Localization States:
    /// - `translated` - Completed and reviewed translation
    /// - `needs_review` - Translation needs review
    /// - `stale` - Translation may be outdated
    ///
    /// # Configuration
    /// ```yaml
    /// rules:
    ///   reject-localization-state:
    ///     value: "needs_review"  # or values: ["needs_review", "stale"]
    ///     severity: error
    /// ```
    ///
    /// # Examples
    ///
    /// **Valid (translated state when rejecting needs_review):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { 
    ///       "stringUnit": { 
    ///         "state": "translated", 
    ///         "value": "Hello World" 
    ///       } 
    ///     }
    ///   }
    /// }
    /// ```
    ///
    /// **Invalid (needs_review state when rejecting needs_review):**
    /// ```json
    /// {
    ///   "localizations": {
    ///     "en": { 
    ///       "stringUnit": { 
    ///         "state": "needs_review", 
    ///         "value": "Hello World" 
    ///       } 
    ///     }
    ///   }
    /// }
    /// ```
    public struct RejectLocalizationState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "reject-localization-state"
        public static let description = "Rejects a localization if its state matches one of the provided values"

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations else {
                if states.contains(Rules.emptyLocalizationState) {
                    return fail(message: "should not have empty translation state")
                }
                return success
            }

            return localizations.flatMap { key, value in
                value.stringUnits.compactMap {
                    if states.contains($0.state) {
                        return String(localized: "should not have state `\($0.state)`", bundle: .module)
                    }
                    return nil
                }
            }.map(fail)
        }
    }
}

extension Rules {
    fileprivate static var emptyLocalizationState: String {
        "empty"
    }
}

extension Rules.RequireLocalizationState {
    public init(in states: String...) {
        self.states = states
    }

    public init(_ state: String) {
        self.states = [state]
    }
}

extension Rules.RejectLocalizationState {
    public init(in states: String...) {
        self.states = states
    }

    public init(_ state: String) {
        self.states = [state]
    }
}
