import StringCatalogValidator
import ArgumentParser

struct CommandLineReporter: Reporter {
    private let print: Printer
    let path: String

    init(
        path: String,
        printer: Printer = PrintPrinter()
    ) {
        self.path = path
        self.print = printer
    }

    func report(results: [Validator.Validation]) throws {
        for result in results {
            let message = "xcstringslint failed for key `\(result.key)`: " + result.validations.map { validation in
                "\(validation.message) (\(type(of: validation.rule).name))"
            }.joined(separator: ",")

            if result.validations.map(\.rule.severity).contains(.error) {
                print(message)
            } else {
                print(message)
            }
        }

        let errorCount = results.flatMap { result in
            result.validations
        }
            .filter { $0.rule.severity == .error }

        if !errorCount.isEmpty {
            print("Found \(results.count) total xcstringlint issues, \(errorCount) serious")
            throw ExitCode.failure
        } else if !results.isEmpty {
            print("Found \(results.count) total xcstringlint issues")
        }
    }
}
