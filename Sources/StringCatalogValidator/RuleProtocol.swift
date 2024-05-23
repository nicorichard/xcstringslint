import Foundation
import StringCatalogDecodable

public protocol ValidationProtocol {
    typealias Entry = StringCatalog.Entry
    func validate(key: String, value: Entry) -> [ValidationFailed]
}

public protocol RuleProtocol: ValidationProtocol {
    var name: String { get }
}
