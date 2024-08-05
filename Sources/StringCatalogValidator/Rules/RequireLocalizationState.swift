import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireLocalizationState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "require-localization-state"
        public static let description: String = String(localized: "Requires that each localization's state matches one of the provided values. Know localization states: \(LocalizationState.allCases.map({"`\($0)`"}).joined(separator: ", "))")

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
    public struct RejectLocalizationState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "reject-localization-state"
        public static let description: String = String(localized: "Rejects a localization if its state matches one of the provided values. Know localization states: \(LocalizationState.allCases.map({"`\($0)`"}).joined(separator: ", "))")

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
