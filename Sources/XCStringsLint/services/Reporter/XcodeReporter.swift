import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

struct XcodeReporter: Reporter {
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
                print(level: .error, message)
            } else {
                print(level: .warning, message)
            }
        }

        let validations = results.flatMap { result in
            result.validations
        }

        let errors = validations.filter { $0.severity == .error }

        if !errors.isEmpty {
            print(level: .error, "Found \(validations.count) total xcstringlint issues in \(results.count) keys, \(errors.count) serious")
            throw ExitCode.failure
        } else if !results.isEmpty {
            print(level: .warning, "Found \(validations.count) total xcstringlint issues in \(results.count) keys")
        }
    }
}

extension XcodeReporter {
    private func print(level: XcodeTag.Level, _ message: String) {
        print(tag(level: level, message))
    }

    private func tag(level: XcodeTag.Level, _ message: String) -> String {
        var tag = XcodeTag()

        tag.setLocation(path: path)
        tag.level = level

        return tag.description + " " + message
    }
}

private struct XcodeTag: CustomStringConvertible {
    var level: Level = .info

    enum Level: CustomStringConvertible {
        case info
        case warning
        case error

        var description: String {
            switch self {
                case .info:
                    return "info:"
                case .warning:
                    return "warning:"
                case .error:
                    return "error:"
            }
        }
    }

    var location: String?

    mutating func setLocation(
        path: String,
        line: Int = 1,
        column: Int = 1
    ) {
        self.location = "\(path):\(line):\(column):"
    }

    var description: String {
        [location, level.description]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}
