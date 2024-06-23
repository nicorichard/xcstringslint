import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireExtractionState: Rule {
        let states: [String]
        public var severity: Severity = .error

        public static let name = "require-extraction-state"
        public static let description: String = String(localized: "Requires that each key's extraction state matches one of the provided values. Known extractions states:  \(ExtractionState.allCases.map({"`\($0)`"}).joined(separator: ", "))")

        public init(in states: [String]) {
            self.states = states
        }

        public init(in states: String...) {
            self.states = states
        }

        public init(state: String?) {
            self.states = [state ?? Self.defaultExtractionState]
        }

        static var defaultExtractionState: String {
            ExtractionState.automatic.rawValue
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            let actualState = value.extractionState ?? Self.defaultExtractionState

            if (states.contains(actualState)) { return success }

            let message = String(localized: "should not have extraction state `\(actualState)`", bundle: .module)

            return fail(message: message)
        }
    }

    public struct RejectExtractionState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "reject-extraction-state"
        public static let description: String = String(localized: "Rejects an entry if its extraction state matchs any of the provided values. Known extractions states:  \(ExtractionState.allCases.map({"`\($0)`"}).joined(separator: ", "))")

        public init(state: String?) {
            self.states = [state ?? Self.defaultExtractionState]
        }

        public init(in states: [String]) {
            self.states = states
        }

        public init(in states: String...) {
            self.states = states
        }

        static var defaultExtractionState: String {
            ExtractionState.automatic.rawValue
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            let state = value.extractionState ?? Self.defaultExtractionState
            if (!states.contains(state)) { return success }

            let message = String(localized: "should not have state \(state)", bundle: .module)

            return fail(message: message)
        }
    }
}
