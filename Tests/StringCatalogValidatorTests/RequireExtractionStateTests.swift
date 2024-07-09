import XCTest
import StringCatalogValidator

class RequireExtractionStateTests: XCTestCase {
    func testRequireExtractionStateMatchesValue_success() throws {
        let sut = Rules.RequireExtractionState(state: "test")

        let json = """
        {
            "extractionState": "test"
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRequireExtractionStateMatchesAutomatic_success() throws {
        let sut = Rules.RequireExtractionState(state: nil)

        let json = """
        {
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRequireExtractionStateMatchesValue_failsForAutomatic() throws {
        let sut = Rules.RequireExtractionState(state: "test")

        let json = """
        {
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-extraction-state"])
    }

    func testRequireExtractionStateMatchesValue_failsForOther() throws {
        let sut = Rules.RequireExtractionState(state: "test")

        let json = """
        {
            "extractionState": "other"
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-extraction-state"])
    }

    func testRequireExtractionStateMatchesAutomatic_fail() throws {
        let sut = Rules.RequireExtractionState(state: nil)

        let json = """
        {
            "extractionState": "stale"
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["require-extraction-state"])
    }
}
