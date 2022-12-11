@testable import DOTGraphTransformer
import XCTest

final class DOTGraphTransformerTests: XCTestCase {
    func testTransformsGraphToDotSyntax() throws {
        let transformer = DOTGraphTransformer()
        let string = try transformer.transform(.mock)
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
