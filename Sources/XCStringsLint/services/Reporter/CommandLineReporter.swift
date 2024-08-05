import StringCatalogValidator
import ArgumentParser
import Foundation

struct CommandLineReporter: Reporter {
    private let print: Printer
    let path: String
    let strict: Bool

    init(
        path: String,
        strict: Bool,
        printer: Printer = PrintPrinter()
    ) {
        self.path = path
        self.strict = strict
        self.print = printer
    }

    func report(results: [Validator.Validation]) throws {
        for result in results {
            print("`\(result.key)`:")
            for validation in result.validations {
                print("  \(validation.severity.symbol) \(validation.name): \(validation.message)")
            }
        }

        let validations = results.flatMap(\.validations)

        let errorCount = validations.filter {
            if strict {
                return true
            } else {
                return $0.severity == .error
            }
        }.count

        let message = String(
            AttributedString(
                localized: "Found ^[\(validations.count) total issue](inflect: true) in ^[\(results.count) key](inflect: true)"
            ).characters
        )

        if errorCount > 0 {
            print(message + ", \(errorCount) serious")
            throw ExitCode.failure
        } else if !results.isEmpty {
            print(message)
        }
    }
}

extension Severity {
    fileprivate var symbol: String {
        switch self {
        case .error:
            return "❌"
        case .warning:
            return "⚠️"
        }
    }
}
