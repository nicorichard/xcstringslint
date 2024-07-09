import XCTest
import StringCatalogValidator

class IgnoreTests: XCTestCase {
    func test_givenShouldTranslateIsFalse_whenIgnoreIsCalled_falseIsReturned() {
        let sut = Ignore.default

        let result = sut.ignore(
            key: "",
            rule: "",
            value: .init(shouldTranslate: false)
        )

        XCTAssertTrue(result)
    }

    func test_givenShouldTranslateIsTrue_whenIgnoreIsCalled_falseIsReturned() {
        let sut = Ignore.default

        let result = sut.ignore(
            key: "",
            rule: "",
            value: .init(shouldTranslate: true)
        )

        XCTAssertFalse(result)
    }

    func test_givenCommentContainsNoLint_whenIgnoreIsCalled_trueIsReturned() {
        let sut = Ignore.default

        let result = sut.ignore(
            key: "",
            rule: "",
            value: .init(comment: "[no-lint]")
        )

        XCTAssertTrue(result)
    }

    func test_givenCommentContainsNoLint_whenTheSpecializedRuleMatches_falseIsReturned() {
        let sut = Ignore.default

        let result = sut.ignore(
            key: "",
            rule: "rule",
            value: .init(comment: "[no-lint:rule]")
        )

        XCTAssertTrue(result)
    }

    func test_givenCommentContainsNoLint_whenTheSpecializedRuleDoesNotMatch_trueIsReturned() {
        let sut = Ignore.default

        let result = sut.ignore(
            key: "",
            rule: "rule",
            value: .init(comment: "[no-lint:another-rule]")
        )

        XCTAssertFalse(result)
    }
}
