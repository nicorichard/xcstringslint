public protocol RuleConvertible: RuleProtocol {
    associatedtype R: RuleProtocol
    var rule: R { get }
}

extension RuleConvertible {
    public var name: String {
        rule.name
    }

    public func validate(key: String, value: Entry) -> [ValidationFailed] {
        rule.validate(key: key, value: value)
    }
}
