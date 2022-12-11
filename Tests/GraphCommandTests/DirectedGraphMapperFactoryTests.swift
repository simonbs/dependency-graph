import DirectedGraph
import DirectedGraphMapper
@testable import GraphCommand
import XCTest

final class DirectedGraphMapperFactoryTests: XCTestCase {
    func testReturnsDotGraphMapper() throws {
        let dotGraphMapper = DOTGraphMapperMock()
        let mermaidGraphMapper = MermaidGraphMapperMock()
        let factory = DirectedGraphMapperFactory(dotGraphMapper: dotGraphMapper, mermaidGraphMapper: mermaidGraphMapper)
        let mapper = factory.mapper(for: .dot)
        let str = try mapper.map(DirectedGraph())
        XCTAssertEqual(str, "dot")
    }

    func testReturnsMermaidGraphMapper() throws {
        let dotGraphMapper = DOTGraphMapperMock()
        let mermaidGraphMapper = MermaidGraphMapperMock()
        let factory = DirectedGraphMapperFactory(dotGraphMapper: dotGraphMapper, mermaidGraphMapper: mermaidGraphMapper)
        let mapper = factory.mapper(for: .mermaid)
        let str = try mapper.map(DirectedGraph())
        XCTAssertEqual(str, "mermaid")
    }
}

private struct DOTGraphMapperMock: DirectedGraphMapper {
    func map(_ graph: DirectedGraph) throws -> String {
        return "dot"
    }
}

private struct MermaidGraphMapperMock: DirectedGraphMapper {
    func map(_ graph: DirectedGraph) throws -> String {
        return "mermaid"
    }
}
