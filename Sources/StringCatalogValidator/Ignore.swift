import StringCatalogDecodable

public protocol IgnoreProtocol {
    func ignore(key: String, value: StringCatalog.Entry) -> Bool
}

public struct Ignore: IgnoreProtocol {
    let ignoreFn: (_ key: String, _ value: StringCatalog.Entry) -> Bool

    public init(ignore: @escaping (_: String, _: StringCatalog.Entry) -> Bool) {
        self.ignoreFn = ignore
    }

    public func ignore(key: String, value: StringCatalog.Entry) -> Bool {
        ignoreFn(key, value)
    }
}

extension Ignore {
    public static let `default` = Ignore { _, value in
        value.comment?.contains("[no lint]") ?? false
    }
}
