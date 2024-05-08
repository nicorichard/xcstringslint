import Foundation

extension Rules {
    public static func requireExtractionState(state: String?) -> Rule {
        Rule("require-extraction-state") { key, value in
            if (value.extractionState == state) { return nil }

            return switch state {
                case .none: String(localized: "is not marked as empty", bundle: .module)
                case .some(let state): String(localized: "is not marked as \(state)", bundle: .module)
            }
        }
    }

    public static func rejectExtractionState(state: String) -> Rule {
        Rule("reject-extraction-state") { key, value in
            if (value.extractionState != state) { return nil }

            return String(localized: "should not have state \(state)", bundle: .module)
        }
    }
}
