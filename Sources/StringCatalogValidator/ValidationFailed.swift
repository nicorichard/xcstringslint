import Foundation
import StringCatalogDecodable

public struct ValidationFailed {
    public let key: String
    public let value: RuleProtocol.Entry
    public let rule: String
    public let message: String
}
