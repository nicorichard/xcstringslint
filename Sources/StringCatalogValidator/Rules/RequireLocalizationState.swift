import Foundation
import StringCatalogDecodable

extension Rules {
    public static func requireLocalizationState(state: String) -> Rule {
        requireLocalizationState(state: Localization.StringUnit.State(from: state))
    }

    public static func requireLocalizationState(state: Localization.StringUnit.State) -> Rule {
        Rule("require-localization-state") { key, value in
            guard let localizations = value.localizations else { return nil }

            let success = localizations.allSatisfy { key, value in
                value.allUnits.allSatisfy {
                    $0.state == state
                }
            }

            if success {
                return nil
            }

            return String(localized: "is not marked `\(state.description)`", bundle: .module)
        }
    }

    public static let requireTranslated: Rule = requireLocalizationState(state: .translated)
}
