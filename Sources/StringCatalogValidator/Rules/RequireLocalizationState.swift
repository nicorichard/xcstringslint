import Foundation
import StringCatalogDecodable

extension Rules {
    public static func requireLocalizationState(_ states: String...) -> Rule {
        requireLocalizationState(states)
    }

    public static func requireLocalizationState(_ states: [String]) -> Rule {
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

    public static func rejectLocalizationState(_ state: String) -> Rule {
        Rule("reject-localization-state") { key, value in
            guard let localizations = value.localizations else { return nil }

            let success = localizations.allSatisfy { key, value in
                value.stringUnits.allSatisfy {
                    $0.state == state
                }
            }

            if success {
                return String(localized: "should not have state `\(state)`", bundle: .module)
            }

            return nil
        }
    }

    public static let requireTranslated: Rule = requireLocalizationState("translated")
}
