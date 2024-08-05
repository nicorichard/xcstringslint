import Foundation
import StringCatalogDecodable

extension Rules {

    // MARK: - RequireExtractionState

    public struct RequireExtractionState: Rule {
        let states: [String]
        public var severity: Severity = .error

        public static let name = "require-extraction-state"
        public static let description: String = String(localized: "Requires that each key's extraction state matches one of the provided values. Known extractions states:  \(ExtractionState.allCases.map({"`\($0)`"}).joined(separator: ", "))")

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            let actualState = value.extractionState ?? Rules.defaultExtractionState

            if (states.contains(actualState)) { return success }

            let message = String(localized: "should not have extraction state `\(actualState)`", bundle: .module)

            return fail(message: message)
        }
    }

    // MARK: - RejectExtractionState

    public struct RejectExtractionState: Rule {
        let states: [String]
        public var severity: Severity = .error
        public static let name = "reject-extraction-state"
        public static let description: String = String(localized: "Rejects an entry if its extraction state matches any of the provided values. Known extractions states:  \(ExtractionState.allCases.map({"`\($0)`"}).joined(separator: ", "))")

        public init(in states: [String]) {
            self.states = states
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            let state = value.extractionState ?? Rules.defaultExtractionState
            if (!states.contains(state)) { return success }

            let message = String(localized: "should not have state \(state)", bundle: .module)

            return fail(message: message)
        }
    }
}

// MARK: - Extensions

extension Rules {
    fileprivate static var defaultExtractionState: String {
        ExtractionState.automatic.rawValue
    }
}

extension Rules.RequireExtractionState {
    public init(in states: String...) {
        self.states = states
    }

    public init(state: String?) {
        self.states = [state ?? Rules.defaultExtractionState]
    }
}

extension Rules.RejectExtractionState {
    public init(in states: String...) {
        self.states = states
    }

    public init(state: String?) {
        self.states = [state ?? Rules.defaultExtractionState]
    }
}
