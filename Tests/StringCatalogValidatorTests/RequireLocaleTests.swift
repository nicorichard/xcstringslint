import XCTest
import StringCatalogValidator

class RequireLocaleTests: XCTestCase {
    func testRequireLocale_givenNoVariations_aSingleLocale_andAMatch_succeeds() throws {
        let sut = Rules.RequireLocale(in: "en")

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "state",
                        "value": "value"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRequireLocale_givenNoVariations_aSingleLocale_andNoMatch_fails() throws {
        let sut = Rules.RequireLocale(in: "fr")

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "state",
                        "value": "value"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.rule), ["require-locale"])
    }

    func testRequireLocale_givenNoVariations_multipleLocales_andFullMatch_succeeds() throws {
        let sut = Rules.RequireLocale(in: "en", "fr")

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "state",
                        "value": "value"
                    }
                },
                "fr": {
                    "stringUnit": {
                        "state": "state",
                        "value": "value"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result, [])
    }

    func testRequireLocale_givenNoVariations_multipleLocales_andPartialMatch_fails() throws {
        let sut = Rules.RequireLocale(in: "en", "de")

        let json = """
        {
            "localizations": {
                "en": {
                    "stringUnit": {
                        "state": "state",
                        "value": "value"
                    }
                },
                "fr": {
                    "stringUnit": {
                        "state": "state",
                        "value": "value"
                    }
                }
            }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.rule), ["require-locale"])
    }

    func testRequireLocale_givenVariations_andMatchingLocale_succeeds() throws {
        let sut = Rules.RequireLocale(in: "en")

        let json = """
        {
          "localizations": {
            "en" : {
              "variations" : {
                "plural" : {
                  "one" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "missing translation for locale: %2$@"
                    }
                  },
                  "other" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "missing translation for %1$lld locales: %2$@"
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

    func testRequireLocale_givenVariations_andNoMatch_fails() throws {
        let sut = Rules.RequireLocale(in: "zh")

        let json = """
        {
          "localizations": {
            "en" : {
              "variations" : {
                "plural" : {
                  "one" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "missing translation for locale: %2$@"
                    }
                  },
                  "other" : {
                    "stringUnit" : {
                      "state" : "translated",
                      "value" : "missing translation for %1$lld locales: %2$@"
                    }
                  }
                }
              }
            }
          }
        }
        """

        let result = sut.validate(key: "key", value: try EntryDecoder.entry(from: json))
        XCTAssertEqual(result.map(\.rule), ["require-locale"])
    }
}
