import StringCatalogDecodable

public protocol IgnoreProtocol {
    func ignore(key: String, rule: String, value: StringCatalog.Entry) -> Bool
}

public struct Ignore: IgnoreProtocol {
    let ignoreFn: (_ key: String, _ rule: String, _ value: StringCatalog.Entry) -> Bool

    public init(ignore: @escaping (_: String, _: String, _: StringCatalog.Entry) -> Bool) {
        self.ignoreFn = ignore
    }

    public func ignore(key: String, rule: String, value: StringCatalog.Entry) -> Bool {
        ignoreFn(key, rule, value)
    }
}

extension Ignore {
    public static let `default` = Ignore { _, rule, value in
        value.comment?.contains("[no-lint]")
            ?? value.comment?.contains("[no-lint:\(rule)]")
            ?? false
    }
}
