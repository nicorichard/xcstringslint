import XCTest
import StringCatalogValidator

class RequireMatchingPlaceholdersTests: XCTestCase {
    
    func testRequireMatchingPlaceholders_withConsistentPlaceholders_succeeds() throws {
        let sut = Rules.RequireMatchingPlaceholders()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Hello %@, you have %d messages"
                    }
                },
                "es": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Hola %@, tienes %d mensajes"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "greeting", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
    
    func testRequireMatchingPlaceholders_withMissingPlaceholder_fails() throws {
        let sut = Rules.RequireMatchingPlaceholders()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Hello %@, you have %d messages"
                    }
                },
                "es": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Hola %@, tienes mensajes"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "greeting", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-matching-placeholders"])
        XCTAssertTrue(result.first?.message.contains("missing: %d") == true)
    }
    
    func testRequireMatchingPlaceholders_withExtraPlaceholder_fails() throws {
        let sut = Rules.RequireMatchingPlaceholders()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Hello %@"
                    }
                },
                "fr": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Bonjour %@, %s"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "greeting", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-matching-placeholders"])
        XCTAssertTrue(result.first?.message.contains("unexpected: %s") == true)
    }
    
    func testRequireMatchingPlaceholders_withPositionalPlaceholders_succeeds() throws {
        let sut = Rules.RequireMatchingPlaceholders()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "%1$@ has %2$d messages"
                    }
                },
                "de": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "%1$@ hat %2$d Nachrichten"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "message_count", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
    
    func testRequireMatchingPlaceholders_withSingleLocale_succeeds() throws {
        let sut = Rules.RequireMatchingPlaceholders()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Hello %@"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "greeting", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
    
    func testRequireMatchingPlaceholders_staticValidation() {
        let issues = Rules.RequireMatchingPlaceholders.validateString(
            "Hello %@, you have messages",
            against: "Hello %@, you have %d messages"
        )
        
        XCTAssertEqual(issues.count, 1)
        XCTAssertTrue(issues.first?.contains("Missing placeholders: %d") == true)
        
        let noIssues = Rules.RequireMatchingPlaceholders.validateString(
            "Hello %@, you have %d messages", 
            against: "Hello %@, you have %d messages"
        )
        XCTAssertEqual(noIssues.count, 0)
    }
}
