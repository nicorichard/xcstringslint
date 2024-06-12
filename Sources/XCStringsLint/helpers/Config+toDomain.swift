import StringCatalogValidator

extension Config.Rule.Severity {
    func toDomain() -> Severity {
        switch self {
            case .error: .error
            case .warning: .warning
        }
    }
}
