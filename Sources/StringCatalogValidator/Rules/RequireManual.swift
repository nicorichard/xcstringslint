import Foundation

extension Rules {
    public static let requireManual = Rule { key, value in
        guard (value.extractionState != "manual") else { return [] }

        return [
            RuleValidation(
                message: String(localized: "is not marked as manual", bundle: .module)
            )
        ]
    }

    public static let requireAutomatic = Rule { key, value in
        guard (value.extractionState == "manual") else { return [] }

        return [
            RuleValidation(
                message: String(localized: "was added manually", bundle: .module)
            )
        ]
    }
}
