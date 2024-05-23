import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireLocalizationState: Rule {
        let states: [String]
        public let name = "require-localization-state"

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            guard let localizations = value.localizations else { return success }

            return localizations.flatMap { key, value in
                value.stringUnits.compactMap {
                    if !states.contains($0.state) {
                        if states.count == 1 {
                            return String(localized: "has state `\($0.state)`, expected one of \(states.joined(separator: ", "))", bundle: .module)
                        } else {
                            return String(localized: "has state `\($0.state)`, expected \(states[0])", bundle: .module)
                        }
                    }
                    return nil
                }
            }.map(fail)
        }
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

extension Rules {
    public struct RejectLocalizationState: Rule {
        let states: [String]
        public let name = "reject-localization-state"

        public init(states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            guard let localizations = value.localizations else { return success }

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

extension Rules.RejectLocalizationState {
    public init(states: String...) {
        self.states = states
    }

    public init(_ state: String) {
        self.states = [state]
    }
}
