@testable import DOTGraphMapper
import XCTest

final class DOTGraphMapperTests: XCTestCase {
    func testMapsGraphToDotSyntax() throws {
        let settings = DOTGraphSettings(nodesep: 1.5, ranksep: 1.2)
        let mapper = DOTGraphMapper(settings: settings)
        let string = try mapper.map(.mock)
        let expectedString = """
digraph g {
  layout=dot
  rankdir=LR
  nodesep=1.5
  ranksep=1.2

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
