import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

struct Reporter {
    private let print = Print()

    func printReport(results: [Validator.Validation], path: String) throws {
        for result in results {
            var message: String

            if result.validations.map(\.rule.severity).contains(.error) {
                message = "error: xcstringslint failed for key `\(result.key)`: "
            } else {
                message = "warning: xcstringslint failed for key `\(result.key)`: "
            }

            message += result.validations.map { validation in
                "\(validation.message) (\(type(of: validation.rule).name))"
            }.joined(separator: ",")

            print(message)
        }

        let errorCount = results.flatMap { result in
            result.validations
        }
            .filter { $0.rule.severity == .error }

        if !errorCount.isEmpty {
            print("error: Found \(results.count) validation issues, \(errorCount) serious in catalog: \(path)")
            throw ExitCode.failure
        } else {
            print("warning: Found \(results.count) validation issues in catalog: \(path)")
        }
    }
}
