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
                "\(validation.message) (\(validation.name))"
            }.joined(separator: ",")

            if result.validations.map(\.severity).contains(.error) {
                print(message)
            } else {
                print(message)
            }
        }

        let validations = results.flatMap { result in
            result.validations
        }

        let errors = validations.filter { $0.severity == .error }

        if !errors.isEmpty {
            print("Found \(results.count) total xcstringlint issues in \(results.count) keys, \(errors.count) serious")
            throw ExitCode.failure
        } else if !results.isEmpty {
            print("Found \(results.count) total xcstringlint issues in \(results.count) keys")
        }
    }
}
