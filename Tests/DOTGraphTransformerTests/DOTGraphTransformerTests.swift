@testable import DOTGraphTransformer
import XCTest

final class DOTGraphTransformerTests: XCTestCase {
    func testTransformsGraphToDotSyntax() throws {
        let transformer = DOTGraphTransformer()
        let string = try transformer.transform(.mock)
        let expectedString = """
digraph g {
  layout=dot

  subgraph Foo {
    label="Foo"
    Foo [label="Foo"]
  }

  subgraph Bar {
    label="Bar"
    Bar [label="Bar"]
  }

  subgraph Baz {
    label="Baz"
    Baz [label="Baz"]
  }

  Foo -> Bar
  Foo -> Baz
}
"""
        XCTAssertEqual(string, expectedString)
    }
}
