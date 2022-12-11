@testable import MermaidGraphMapper
import XCTest

final class MermaidGraphMapperTests: XCTestCase {
    func testMapsGraphToMermaidSyntax() throws {
        let settings = MermaidGraphSettings(nodeSpacing: 100, rankSpacing: 250)
        let mapper = MermaidGraphMapper(settings: settings)
        let string = try mapper.map(.mock)
        let expectedString = """
graph LR
  subgraph Foo[Foo]
    %%{init:{'flowchart':{'nodeSpacing': 100, 'rankSpacing': 250}}}%%
    Foo[Foo]
  end

  subgraph Bar[Bar]
    %%{init:{'flowchart':{'nodeSpacing': 100, 'rankSpacing': 250}}}%%
    Bar[Bar]
  end

  subgraph Baz[Baz]
    %%{init:{'flowchart':{'nodeSpacing': 100, 'rankSpacing': 250}}}%%
    Baz([Baz])
  end

  Foo --> Bar
  Foo --> Baz
"""
        XCTAssertEqual(string, expectedString)
    }
}
