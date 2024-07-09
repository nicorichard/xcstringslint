import XCTest
import StringCatalogValidator

class RejectExtractionStateTests: XCTestCase {
    func testRejectExtractionState_successWithAutomatic() throws {
        let sut = Rules.RejectExtractionState(state: nil)

        let json = """
        {
            "extractionState": "test"
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRejectExtractionState_successWithValue() throws {
        let sut = Rules.RejectExtractionState(state: "test")

        let json = "{}"

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRejectExtractionState_successWithOther() throws {
        let sut = Rules.RejectExtractionState(state: "other")

        let json = """
        {
            "extractionState": "test"
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRejectExtractionState_failWithAutomatic() throws {
        let sut = Rules.RejectExtractionState(state: nil)

        let json = "{}"

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-extraction-state"])
    }


    func testRejectExtractionState_failWithValue() throws {
        let sut = Rules.RejectExtractionState(state: "test")

        let json = """
        {
            "extractionState": "test"
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.name), ["reject-extraction-state"])
    }
}
