import XCTest
import StringCatalogValidator

class RejectEmptyValuesTests: XCTestCase {
    
    func testRejectEmptyValues_withValidValues_succeeds() throws {
        let sut = Rules.RejectEmptyValues()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Save Changes"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
    
    func testRejectEmptyValues_withEmptyValue_fails() throws {
        let sut = Rules.RejectEmptyValues()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": ""
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-empty-values"])
        XCTAssertTrue(result.first?.message.contains("empty value in 'en'") == true)
    }
    
    func testRejectEmptyValues_withWhitespaceOnlyValue_fails() throws {
        let sut = Rules.RejectEmptyValues()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "   \\n\\t  "
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-empty-values"])
        XCTAssertTrue(result.first?.message.contains("whitespace-only value in 'en'") == true)
    }
    
    func testRejectEmptyValues_withMultipleLocales_checksAll() throws {
        let sut = Rules.RejectEmptyValues()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Valid text"
                    }
                },
                "es": {
                    "stringUnit": {
                        "state": "translated",
                        "value": ""
                    }
                },
                "fr": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "   "
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "text", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-empty-values", "reject-empty-values"])
        
        let messages = result.map(\.message)
        XCTAssertTrue(messages.contains { $0.contains("empty value in 'es'") })
        XCTAssertTrue(messages.contains { $0.contains("whitespace-only value in 'fr'") })
    }
    
    func testRejectEmptyValues_withNoLocalizations_succeeds() throws {
        let sut = Rules.RejectEmptyValues()
        
        let json = "{}"
        
        let result = sut.validate(key: "empty", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
}
