import Foundation
import StringCatalogDecodable

extension Rules {
    public struct RequireObjectPlaceholders: Rule {
        public var severity: Severity = .error
        public static let name = "require-object-placeholders"
        public static let description = "Requires that all placeholders are object placeholders (e.g., %@, %1$@)."

        public init() {}

        public func validate(key: String, value: Entry) -> [Failure] {
            guard let localizations = value.localizations else {
                return success
            }

            var failures: [String] = []

            for (locale, localization) in localizations {
                for stringUnit in localization.stringUnits {
                    let placeholders = extractPlaceholders(from: stringUnit.value)
                    let nonObjectPlaceholders = placeholders.filter { !$0.isObjectPlaceholder }

                    if !nonObjectPlaceholders.isEmpty {
                        let message = "Non-object placeholder(s) in '\(locale)': \(nonObjectPlaceholders.map(\.value).joined(separator: ", "))"
                        failures.append(message)
                    }
                }
            }

            return failures.map { fail(message: $0) }
        }
    }
}

private extension Rules.RequireObjectPlaceholders {
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
        var isObjectPlaceholder: Bool {
            return value.hasSuffix("@")
        }
    }
}
