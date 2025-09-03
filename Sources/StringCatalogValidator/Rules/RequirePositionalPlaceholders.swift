import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequirePositionalPlaceholders: Rule {
        public var severity: Severity = .warning
        public static let name = "require-positional-placeholders"
        public static let description = "Requires that all placeholders are positional (e.g., %1$@) when multiple are present."

        private let applyToAll: Bool

        public init(applyToAll: Bool = false) {
            self.applyToAll = applyToAll
        }

        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations else {
                return success
            }

            var failures: [String] = []

            for (locale, localization) in localizations {
                for stringUnit in localization.stringUnits {
                    let placeholders = extractPlaceholders(from: stringUnit.value)
                    
                    guard applyToAll || placeholders.count > 1 else { continue }

                    let nonPositional = placeholders.filter { !$0.isPositional }
                    if !nonPositional.isEmpty {
                        let message = "Non-positional placeholder(s) in '\(locale)': \(nonPositional.map(\.value).joined(separator: ", "))"
                        failures.append(message)
                    }
                }
            }

            return failures.map { fail(message: $0) }
        }
    }
}

private extension Rules.RequirePositionalPlaceholders {
    func extractPlaceholders(from string: String) -> [Placeholder] {
        let pattern = #"%(?:\d+\$)?[-#+ 0]*\*?(?:\d+|\*)?(?:\.(?:\d+|\*))?[hlL]?[@dDuUxXoOfFeEgGaAcspn%]"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        
        let range = NSRange(string.startIndex..<string.endIndex, in: string)
        let matches = regex.matches(in: string, options: [], range: range)
        
        return matches.compactMap { match in
            guard let range = Range(match.range, in: string) else { return nil }
            let value = String(string[range])
            return Placeholder(value: value)
        }
    }

    struct Placeholder {
        let value: String
        var isPositional: Bool {
            value.contains("$")
        }
    }
}
