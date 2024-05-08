import Foundation

extension Rules {
    public static func requireExtractionState(state: String?) -> Rule {
        Rule { key, value in
            guard (value.extractionState == state) else { return [] }

            let message = switch state {
                case .none: String(localized: "is not marked as empty", bundle: .module)
                case .some(let state): String(localized: "is not marked as \(state)", bundle: .module)
            }

            return [
                RuleValidation(message: message)
            ]
        }
    }

    public static let requireManual: Rule = requireExtractionState(state: "manual")
    public static let requireAutomatic = requireExtractionState(state: nil)
}
