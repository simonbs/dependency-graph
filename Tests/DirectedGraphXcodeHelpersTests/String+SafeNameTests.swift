@testable import DirectedGraphXcodeHelpers
import XCTest

// swiftlint:disable:next type_name
final class String_SafeNameTests: XCTestCase {
    func testRemovesDot() {
        let string = "Example.xcodeproj".safeName
        XCTAssertEqual(string, "Examplexcodeproj")
    }
}
