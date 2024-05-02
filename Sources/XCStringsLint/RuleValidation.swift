import Foundation

protocol Rule {
    func run(catalog: Catalog) -> [RuleValidation]
}

struct RuleValidation {
    let key: String
    let message: String
}
