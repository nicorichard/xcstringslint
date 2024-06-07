import StringCatalogValidator

extension Config.Rule.Severity {
    func toDomain() -> Severity {
        return switch self {
            case .error: .error
            case .warning: .warning
        }
    }
}
