import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireExtractionState: RuleConvertible {
        let state: String?

        public init(state: String?) {
            self.state = state
        }

        public var rule: some RuleProtocol {
            Rule("require-extraction-state") { key, value in
                if (value.extractionState == state) { return nil }

                return switch state {
                    case .none: String(localized: "is not marked as empty", bundle: .module)
                    case .some(let state): String(localized: "is not marked as \(state)", bundle: .module)
                }
            }
        }
    }

    public struct RejectExtractionState: RuleConvertible {
        let state: String?

        public init(state: String?) {
            self.state = state
        }

        public var rule: some RuleProtocol {
            Rule("reject-extraction-state") { key, value in
                if (value.extractionState != state) { return nil }

                return switch state {
                    case .none: String(localized: "should not have empty state", bundle: .module)
                    case .some(let state): String(localized: "should not have state \(state)", bundle: .module)
                }
            }
        }
    }
}
