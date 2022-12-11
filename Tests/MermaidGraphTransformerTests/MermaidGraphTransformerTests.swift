@testable import MermaidGraphTransformer
import XCTest

final class MermaidGraphTransformerTests: XCTestCase {
    func testTransformsGraphToMermaidSyntax() throws {
        let transformer = MermaidGraphTransformer()
        let string = try transformer.transform(.mock)
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
