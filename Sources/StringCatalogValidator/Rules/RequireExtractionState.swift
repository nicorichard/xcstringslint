import Foundation

extension Rules {
    public static func requireExtractionState(state: String?) -> Rule {
        Rule("require-extraction-state") { key, value in
            guard (value.extractionState == state) else { return nil }

            return switch state {
                case .none: String(localized: "is not marked as empty", bundle: .module)
                case .some(let state): String(localized: "is not marked as \(state)", bundle: .module)
            }
        }
    }

    public static let requireManual: Rule = requireExtractionState(state: "manual")
    public static let requireAutomatic = requireExtractionState(state: nil)
}
