@testable import D2GraphMapper
import XCTest

final class D2GraphMapperTests: XCTestCase {
    func testMapsGraphToD2Syntax() throws {
        let mapper = D2GraphMapper()
        let string = try mapper.map(.mock)
        let expectedString = """
direction: right

Foo: Foo {
  Foo: Foo
  Foo.shape: rectangle
}

Bar: Bar {
  Bar: Bar
  Bar.shape: rectangle
}

Baz: Baz {
  Baz: Baz
  Baz.shape: oval
}

Foo.Foo -> Bar.Bar
Foo.Foo -> Baz.Baz
"""
        XCTAssertEqual(string, expectedString)
    }

    func testMapsGraphWithRootNodesToD2Syntax() throws {
        let mapper = D2GraphMapper()
        let string = try mapper.map(.mockWithRootNodes)
        let expectedString = """
direction: right

Foo: Foo
Foo.shape: rectangle
Bar: Bar
Bar.shape: rectangle
Baz: Baz
Baz.shape: oval

Foo -> Bar
Foo -> Baz
"""
        XCTAssertEqual(string, expectedString)
    }
}
