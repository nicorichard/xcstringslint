import XCTest
import StringCatalogValidator

class RequireLocalizationStateTests: XCTestCase {
    func test_RequireLocalizationState_empty_succeeds() throws {
        let sut = Rules.RequireLocalizationState("empty")

        let json = "{}"

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func test_RequireLocalizationState_withNoVariations_andMatchingState_succeeds() throws {
        let sut = Rules.RequireLocalizationState("translated")

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "translated",
                        "value": "value"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func test_RequireLocalizationState_withNoVariations_andNonMatchingState_fails() throws {
        let sut = Rules.RequireLocalizationState("translated")

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "stale",
                        "value": "value"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.rule), ["require-localization-state"])
    }

    func test_RequireLocalizationState_withVariations_andMatchingState_succeeds() throws {
        let sut = Rules.RequireLocalizationState("translated")

        let json = """
        {
          "localizations": {
            "en" : {
              "variations" : {
                "plural" : {
                  "one" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "value"
                    }
                  },
                  "other" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "value"
                    }
                  }
                }
              }
            }
          }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func test_RequireLocalizationState_withVariations_andNonMatchingState_fails() throws {
        let sut = Rules.RequireLocalizationState("translated")

        let json = """
        {
          "localizations": {
            "en" : {
              "variations" : {
                "plural" : {
                  "one" : {
                    "stringUnit" : {
                      "state" : "stale",
                      "value" : "value"
                    }
                  },
                  "other" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "value"
                    }
                  }
                }
              }
            }
          }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.rule), ["require-localization-state"])
    }
}
