import XCTest
import StringCatalogValidator

class RequireCommentTests: XCTestCase {
    
    func testRequireComment_withValidComment_succeeds() throws {
        let sut = Rules.RequireComment()
        
        let json = """
        {
            "comment": "Button label for saving user preferences",
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Save"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
    
    func testRequireComment_withoutComment_fails() throws {
        let sut = Rules.RequireComment()
        
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Save"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-comment"])
        XCTAssertTrue(result.first?.message.contains("missing developer comment") == true)
    }
    
    func testRequireComment_withEmptyComment_fails() throws {
        let sut = Rules.RequireComment()
        
        let json = """
        {
            "comment": "   ",
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated", 
                        "value": "Save"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-comment"])
    }
    
    func testRequireComment_withPlaceholderComment_fails() throws {
        let sut = Rules.RequireComment()
        
        let json = """
        {
            "comment": "TODO",
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Save"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-comment"])
        XCTAssertTrue(result.first?.message.contains("placeholder") == true)
    }
    
    func testRequireComment_withShouldTranslateFalse_succeeds() throws {
        let sut = Rules.RequireComment()
        
        let json = """
        {
            "shouldTranslate": false,
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "Save"
                    }
                }
            }
        }
        """
        
        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
}
