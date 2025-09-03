import XCTest
import StringCatalogValidator

class RejectPatternsTests: XCTestCase {

    func testRejectPatterns_withValidValues_succeeds() throws {
        let sut = Rules.RejectPatterns(patterns: ["TODO", "FIXME"])

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

    func testRejectPatterns_withForbiddenPattern_fails() throws {
        let sut = Rules.RejectPatterns(patterns: ["TODO", "FIXME"])

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "TODO: Save Changes"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-patterns"])
        XCTAssertTrue(result.first?.message.contains("'en' translation contains forbidden pattern 'TODO'") == true)
    }

    func testRejectPatterns_withForbiddenPattern_caseInsensitive_fails() throws {
        let sut = Rules.RejectPatterns(patterns: ["todo"], caseSensitive: false)

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "TODO: Save Changes"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-patterns"])
        XCTAssertTrue(result.first?.message.contains("'en' translation contains forbidden pattern 'todo'") == true)
    }

    func testRejectPatterns_withForbiddenPattern_caseSensitive_succeeds() throws {
        let sut = Rules.RejectPatterns(patterns: ["todo"], caseSensitive: true)

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "TODO: Save Changes"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "save_button", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }
}
