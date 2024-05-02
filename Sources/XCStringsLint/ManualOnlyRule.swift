import Foundation

struct ManualOnlyRule: Rule {
    func run(catalog: Catalog) -> [RuleValidation] {
        catalog.strings.reduce([RuleValidation]()) { acc, curr in
            let (key, value) = curr
            if (value.extractionState != "manual") {
                return acc + [RuleValidation(key: key, message: "is not marked as manual")]
            }
            return acc
        }
    }
}
