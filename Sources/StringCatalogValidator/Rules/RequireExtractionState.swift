import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireExtractionState: Rule {
        let state: String?
        public let name = "require-extraction-state"

        public init(state: String?) {
            self.state = state
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            if (value.extractionState == state) { return success }

            let message = switch state {
                case .none: String(localized: "is not marked as empty", bundle: .module)
                case .some(let state): String(localized: "is not marked as \(state)", bundle: .module)
            }

            return fail(message: message)
        }
    }

    public struct RejectExtractionState: Rule {
        let state: String?
        public let name = "reject-extraction-state"

        public init(state: String?) {
            self.state = state
        }

        public func validate(key: String, value: Entry) -> [ValidationFailed] {
            if (value.extractionState != state) { return success }

            let message = switch state {
                case .none: String(localized: "should not have empty state", bundle: .module)
                case .some(let state): String(localized: "should not have state \(state)", bundle: .module)
            }

            return fail(message: message)
        }
    }
}
