import Foundation
import StringCatalogValidator
import StringCatalogDecodable
import ArgumentParser

struct XcodeReporter: Reporter {
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
            for validation in result.validations {
                let message = "`\(result.key)`: \(validation.message) (\(validation.name))"
                switch validation.severity {
                    case .error:
                        print(level: .error, message)
                    case .warning:
                        print(level: .warning, message)
                }
            }
        }

        if (strict && results.validationCount > 0) || results.errorCount > 0 {
            throw ExitCode.failure
        }
    }
}

extension [Validator.Validation] {
    fileprivate var validationCount: Int {
        flatMap(\.validations).count
    }

    fileprivate var errorCount: Int {
        flatMap(\.validations)
            .filter { $0.severity == .error }
            .count
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
