import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireLocalizationState: RuleConvertible {
        let states: [String]

        public init(in states: [String]) {
            self.states = states
        }

        public var rule: some RuleProtocol {
            Rule("require-localization-state") { key, value in
                guard let localizations = value.localizations else { return nil }

                let success = localizations.allSatisfy { key, value in
                    value.stringUnits.allSatisfy {
                        states.contains($0.state)
                    }
                }

                if success {
                    return nil
                }

                if states.count == 1 {
                    return String(localized: "is not marked `\(states[0])`", bundle: .module)
                } else {
                    return String(localized: "is not marked one of \(states.map { "`\($0)`" }.joined(separator: ", "))", bundle: .module)
                }
            }
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
    public struct RejectLocalizationState: RuleProtocol {
        let states: [String]
        public let name = "reject-localization-state"

        public init(states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            guard let localizations = value.localizations else { return [] }

            let messages = localizations.flatMap { key, value in
                value.stringUnits.compactMap {
                    if states.contains($0.state) {
                        return String(localized: "should not have state `\($0.state)`", bundle: .module)
                    }
                    return nil
                }
            }

            return messages.map {
                ValidationFailed(key: key, value: value, rule: "reject-localization-state", message: $0)
            }
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
