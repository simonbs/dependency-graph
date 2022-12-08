@testable import DOTGraphTransformerLive
import XCTest

final class IndentTests: XCTestCase {
    func testStringIsIndented() {
        let string = "foo".indented(by: 1)
        XCTAssertEqual(string, "  foo")
    }

    func testStringIsIndentedByThree() {
        let string = "foo".indented(by: 3)
        XCTAssertEqual(string, "      foo")
    }

    func testStringArrayIsIndented() {
        let stringArray = ["foo", "bar", "baz"].indented(by: 1)
        XCTAssertEqual(stringArray, ["  foo", "  bar", "  baz"])
    }

    func testStringWithLineBreaksIsIndented() {
        let stringArray = "foo\nbar\nbaz".indented(by: 1)
        XCTAssertEqual(stringArray, "  foo\n  bar\n  baz")
    }

    func testArrayOfStringsWithLineBreaksIsIndented() {
        let stringArray = ["foo\nbar\nbaz", "foo\nbar\nbaz"].indented(by: 1)
        XCTAssertEqual(stringArray, ["  foo\n  bar\n  baz", "  foo\n  bar\n  baz"])
    }

    func testIndentStringWithTwoLineBreaks() {
        let string = "foo\n\nbar".indented(by: 1)
        XCTAssertEqual(string, "  foo\n\n  bar")
    }
}
