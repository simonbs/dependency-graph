import DirectedGraph
import DirectedGraphWriter
@testable import GraphCommand
import XCTest

final class DirectedGraphWriterFactoryTests: XCTestCase {
    func testReturnsDotGraphMapper() throws {
        let dotGrapWriter = DOTGraphWriterMock()
        let mermaidGraphWriter = MermaidGraphWriterMock()
        let factory = DirectedGraphWriterFactory(dotGraphWriter: dotGrapWriter, mermaidGraphWriter: mermaidGraphWriter)
        let writer = factory.writer(for: .dot)
        XCTAssertTrue(writer is DOTGraphWriterMock)
    }

    func testReturnsMermaidGraphMapper() throws {
        let dotGrapWriter = DOTGraphWriterMock()
        let mermaidGraphWriter = MermaidGraphWriterMock()
        let factory = DirectedGraphWriterFactory(dotGraphWriter: dotGrapWriter, mermaidGraphWriter: mermaidGraphWriter)
        let writer = factory.writer(for: .mermaid)
        XCTAssertTrue(writer is MermaidGraphWriterMock)
    }
}

private struct DOTGraphWriterMock: DirectedGraphWriter {
    func write(_ directedGraph: DirectedGraph) throws {}
}

private struct MermaidGraphWriterMock: DirectedGraphWriter {
    func write(_ directedGraph: DirectedGraph) throws {}
}
