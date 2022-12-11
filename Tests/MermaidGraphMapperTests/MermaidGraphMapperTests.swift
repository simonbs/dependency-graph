@testable import MermaidGraphMapper
import XCTest

final class MermaidGraphMapperTests: XCTestCase {
    func testMapsGraphToMermaidSyntax() throws {
        let mapper = MermaidGraphMapper()
        let string = try mapper.map(.mock)
        let expectedString = """
graph TB
  subgraph Foo[Foo]
    Foo[Foo]
  end

  subgraph Bar[Bar]
    Bar[Bar]
  end

  subgraph Baz[Baz]
    Baz([Baz])
  end

  Foo --> Bar
  Foo --> Baz
"""
        XCTAssertEqual(string, expectedString)
    }
}
