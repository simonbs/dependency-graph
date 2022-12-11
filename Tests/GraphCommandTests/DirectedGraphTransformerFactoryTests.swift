import DirectedGraph
import DirectedGraphTransformer
@testable import GraphCommand
import XCTest

final class DirectedGraphTransformerFactoryTests: XCTestCase {
    func testReturnsDotGraphTransformer() throws {
        let dotGraphTransformer = DOTGraphTransformerMock()
        let mermaidGraphTransformer = MermaidGraphTransformerMock()
        let factory = DirectedGraphTransformerFactory(dotGraphTransformer: dotGraphTransformer, mermaidGraphTransformer: mermaidGraphTransformer)
        let transformer = factory.transformer(for: .dot)
        let str = try transformer.transform(DirectedGraph())
        XCTAssertEqual(str, "dot")
    }

    func testReturnsMermaidGraphTransformer() throws {
        let dotGraphTransformer = DOTGraphTransformerMock()
        let mermaidGraphTransformer = MermaidGraphTransformerMock()
        let factory = DirectedGraphTransformerFactory(dotGraphTransformer: dotGraphTransformer, mermaidGraphTransformer: mermaidGraphTransformer)
        let transformer = factory.transformer(for: .mermaid)
        let str = try transformer.transform(DirectedGraph())
        XCTAssertEqual(str, "mermaid")
    }
}

private struct DOTGraphTransformerMock: DirectedGraphTransformer {
    func transform(_ graph: DirectedGraph) throws -> String {
        return "dot"
    }
}

private struct MermaidGraphTransformerMock: DirectedGraphTransformer {
    func transform(_ graph: DirectedGraph) throws -> String {
        return "mermaid"
    }
}
