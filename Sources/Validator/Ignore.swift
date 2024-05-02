public protocol IgnoreProtocol {
    func ignore(key: String, value: Catalog.CatalogString) -> Bool
}

public struct Ignore: IgnoreProtocol {
    let ignoreFn: (_ key: String, _ value: Catalog.CatalogString) -> Bool

    public init(ignore: @escaping (_: String, _: Catalog.CatalogString) -> Bool) {
        self.ignoreFn = ignore
    }

    public func ignore(key: String, value: Catalog.CatalogString) -> Bool {
        ignoreFn(key, value)
    }
}

extension Ignore {
    public static let `default` = Ignore { _, value in
        value.comment?.contains("[no lint]") ?? false
    }
}
