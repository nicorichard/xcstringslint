import StringCatalogValidator

protocol Reporter {
    func report(results: [Validator.Validation]) throws
}
