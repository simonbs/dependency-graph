@testable import DOTGraphMapper
import XCTest

final class DOTGraphMapperTests: XCTestCase {
    func testMapsGraphToDotSyntax() throws {
        let mapper = DOTGraphMapper()
        let string = try mapper.map(.mock)
        let expectedString = """
digraph g {
  layout=dot

  subgraph cluster_Foo {
    label="Foo"
    Foo [label="Foo", shape=box]
  }

  subgraph cluster_Bar {
    label="Bar"
    Bar [label="Bar", shape=box]
  }

  subgraph cluster_Baz {
    label="Baz"
    Baz [label="Baz", shape=ellipse]
  }

  Foo -> Bar
  Foo -> Baz
}
"""
        XCTAssertEqual(string, expectedString)
    }
}
