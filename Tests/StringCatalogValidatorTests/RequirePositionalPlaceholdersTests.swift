import XCTest
@testable import StringCatalogValidator

class RequirePositionalPlaceholdersTests: XCTestCase {

    func test_withMultipleNonPositionalPlaceholders_fails() throws {
        let sut = Rules.RequirePositionalPlaceholders()
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
        XCTAssertEqual(result.first?.name, "require-positional-placeholders")
        XCTAssertTrue(result.first!.message.contains("Non-positional placeholder(s) in 'en': %@, %d"))
    }

    func test_withPositionalPlaceholders_succeeds() throws {
        let sut = Rules.RequirePositionalPlaceholders()
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": { "state": "translated", "value": "Hello %1$@, you have %2$d messages" }
                }
            }
        }
        """
        let result = sut.validate(key: "test", value: try EntryDecoder.entry(from: json))
        XCTAssertTrue(result.isEmpty)
    }

    func test_withSinglePlaceholder_succeedsByDefault() throws {
        let sut = Rules.RequirePositionalPlaceholders()
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": { "state": "translated", "value": "Hello %@" }
                }
            }
        }
        """
        let result = sut.validate(key: "test", value: try EntryDecoder.entry(from: json))
        XCTAssertTrue(result.isEmpty)
    }

    func test_withSinglePlaceholder_andApplyToAll_fails() throws {
        let sut = Rules.RequirePositionalPlaceholders(applyToAll: true)
        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": { "state": "translated", "value": "Hello %@" }
                }
            }
        }
        """
        let result = sut.validate(key: "test", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.first!.message.contains("Non-positional placeholder(s) in 'en': %@"))
    }
}
