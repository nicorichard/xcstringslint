import XCTest
@testable import StringCatalogValidator

class RequireObjectPlaceholdersTests: XCTestCase {

    func test_withObjectPlaceholders_succeeds() throws {
        let sut = Rules.RequireObjectPlaceholders()
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": { "state": "translated", "value": "Hello %1$@, you have %@" }
                }
            }
        }
        """
        let result = sut.validate(key: "test", value: try EntryDecoder.entry(from: json))
        XCTAssertTrue(result.isEmpty)
    }

    func test_withNonObjectPlaceholders_fails() throws {
        let sut = Rules.RequireObjectPlaceholders()
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": { "state": "translated", "value": "You have %d messages and %f problems" }
                }
            }
        }
        """
        let result = sut.validate(key: "test", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "require-object-placeholders")
        XCTAssertTrue(result.first!.message.contains("Non-object placeholder(s) in 'en': %d, %f"))
    }

    func test_withMixedPlaceholders_fails() throws {
        let sut = Rules.RequireObjectPlaceholders()
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": { "state": "translated", "value": "Hello %@, you have %d messages" }
                }
            }
        }
        """
        let result = sut.validate(key: "test", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.first!.message.contains("Non-object placeholder(s) in 'en': %d"))
    }
}
