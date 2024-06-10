import StringCatalogValidator

// TODO: Add a cli reporter that doesn't include all the Xcode garbage
// TODO: Add a json reporter that can be used to output the results in a machine readable format
protocol Reporter {
    func report(results: [Validator.Validation]) throws
}
