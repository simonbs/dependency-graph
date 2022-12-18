import DirectedGraph
import DirectedGraphWriter
@testable import GraphCommand
import XCTest

final class DirectedGraphWriterFactoryTests: XCTestCase {
    func testReturnsD2GraphMapper() throws {
        let d2GrapWriter = D2GraphWriterMock()
        let dotGrapWriter = DOTGraphWriterMock()
        let mermaidGraphWriter = MermaidGraphWriterMock()
        let factory = DirectedGraphWriterFactory(d2GraphWriter: d2GrapWriter, dotGraphWriter: dotGrapWriter, mermaidGraphWriter: mermaidGraphWriter)
        let writer = factory.writer(for: .d2)
        XCTAssertTrue(writer is D2GraphWriterMock)
    }

    func testReturnsDotGraphMapper() throws {
        let d2GrapWriter = DOTGraphWriterMock()
        let dotGrapWriter = DOTGraphWriterMock()
        let mermaidGraphWriter = MermaidGraphWriterMock()
        let factory = DirectedGraphWriterFactory(d2GraphWriter: d2GrapWriter, dotGraphWriter: dotGrapWriter, mermaidGraphWriter: mermaidGraphWriter)
        let writer = factory.writer(for: .dot)
        XCTAssertTrue(writer is DOTGraphWriterMock)
    }

    func testReturnsMermaidGraphMapper() throws {
        let d2GrapWriter = DOTGraphWriterMock()
        let dotGrapWriter = DOTGraphWriterMock()
        let mermaidGraphWriter = MermaidGraphWriterMock()
        let factory = DirectedGraphWriterFactory(d2GraphWriter: d2GrapWriter, dotGraphWriter: dotGrapWriter, mermaidGraphWriter: mermaidGraphWriter)
        let writer = factory.writer(for: .mermaid)
        XCTAssertTrue(writer is MermaidGraphWriterMock)
    }
}

private struct D2GraphWriterMock: DirectedGraphWriter {
    func write(_ directedGraph: DirectedGraph) throws {}
}

private struct DOTGraphWriterMock: DirectedGraphWriter {
    func write(_ directedGraph: DirectedGraph) throws {}
}

private struct MermaidGraphWriterMock: DirectedGraphWriter {
    func write(_ directedGraph: DirectedGraph) throws {}
}
