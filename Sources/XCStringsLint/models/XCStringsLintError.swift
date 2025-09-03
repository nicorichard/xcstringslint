import Foundation
import ArgumentParser
import StringCatalogValidator

/// Comprehensive error types for XCStringsLint
enum XCStringsLintError: LocalizedError {
    case invalidConfigFile(path: String, reason: String)
    case missingXCStringsFile(path: String)
    case unsupportedRule(name: String, availableRules: [String])
    case invalidRuleConfiguration(rule: String, reason: String)
    case corruptedXCStringsFile(path: String, reason: String)
    case fileSystemError(operation: String, path: String, underlyingError: Error?)
    
    var errorDescription: String? {
        switch self {
        case .invalidConfigFile(let path, let reason):
            return "Invalid configuration file at '\(path)': \(reason)"
        case .missingXCStringsFile(let path):
            return "No .xcstrings file found at path: \(path)"
        case .unsupportedRule(let name, let availableRules):
            return """
            Unknown rule '\(name)'. 
            Available rules: \(availableRules.joined(separator: ", "))
            Run 'xcstringslint rules' to see detailed descriptions.
            """
        case .invalidRuleConfiguration(let rule, let reason):
            return "Invalid configuration for rule '\(rule)': \(reason)"
        case .corruptedXCStringsFile(let path, let reason):
            return "Corrupted or invalid .xcstrings file at '\(path)': \(reason)"
        case .fileSystemError(let operation, let path, let underlyingError):
            var message = "File system error during \(operation) at path '\(path)'"
            if let underlyingError = underlyingError {
                message += ": \(underlyingError.localizedDescription)"
            }
            return message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidConfigFile:
            return "Check the YAML syntax and ensure all required fields are present."
        case .missingXCStringsFile:
            return "Verify the path is correct or run from the directory containing .xcstrings files."
        case .unsupportedRule:
            return "Check for typos in rule names or update to the latest version."
        case .invalidRuleConfiguration:
            return "Refer to the documentation for correct rule configuration format."
        case .corruptedXCStringsFile:
            return "Regenerate the .xcstrings file in Xcode or restore from version control."
        case .fileSystemError:
            return "Check file permissions and disk space."
        }
    }
}

/// Enhanced validation error with better context
struct DetailedValidationError: Error, CustomStringConvertible {
    let message: String
    let file: String?
    let line: Int?
    let column: Int?
    let severity: Severity
    
    init(message: String, file: String? = nil, line: Int? = nil, column: Int? = nil, severity: Severity = .error) {
        self.message = message
        self.file = file
        self.line = line
        self.column = column
        self.severity = severity
    }
    
    var description: String {
        var result = message
        if let file = file {
            result = "\(file): \(result)"
            if let line = line {
                result = "\(file):\(line): \(result)"
                if let column = column {
                    result = "\(file):\(line):\(column): \(result)"
                }
            }
        }
        return result
    }
}

/// Error recovery and user guidance utilities
struct ErrorRecovery {
    /// Provides suggestions for common configuration mistakes
    static func suggestConfigFixes(for error: Error, configPath: String) -> [String] {
        var suggestions: [String] = []
        
        if let yamlError = error as? YamlError {
            suggestions.append("Check YAML syntax at line \(yamlError.line ?? 0)")
            suggestions.append("Ensure proper indentation (use spaces, not tabs)")
        }
        
        suggestions.append("Validate your configuration against the schema")
        suggestions.append("Check the example configuration at: https://github.com/nicorichard/xcstringslint/blob/main/.xcstringslint.yaml")
        
        return suggestions
    }
    
    /// Provides suggestions for missing files
    static func suggestFileFixes(for missingPath: String) -> [String] {
        var suggestions: [String] = []
        
        if missingPath.hasSuffix(".xcstrings") {
            suggestions.append("Ensure the .xcstrings file exists at the specified path")
            suggestions.append("Check if the file was moved or renamed in Xcode")
            suggestions.append("Try running from the project root directory")
        } else if missingPath.contains("xcstringslint") {
            suggestions.append("Create a .xcstringslint.yaml configuration file")
            suggestions.append("Run 'xcstringslint init' to create a default configuration")
        }
        
        return suggestions
    }
}

// MARK: - YAML Parsing Error Handling

struct YamlError: Error {
    let line: Int?
    let column: Int?
    let description: String
    
    init(line: Int? = nil, column: Int? = nil, description: String) {
        self.line = line
        self.column = column
        self.description = description
    }
}
