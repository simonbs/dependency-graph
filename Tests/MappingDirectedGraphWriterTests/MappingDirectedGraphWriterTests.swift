import DirectedGraph
import DirectedGraphMapper
@testable import MappingDirectedGraphWriter
import Writer
import XCTest

final class MappingDirectedGraphWriterTests: XCTestCase {
    func testInvokesMapper() throws {
        let mapper = DirectedGraphMapperMock()
        let writer = WriterMock()
        let obj = MappingDirectedGraphWriter(mapper: mapper, writer: writer)
        let graph = DirectedGraph()
        try obj.write(graph)
        XCTAssertTrue(mapper.didMap)
    }

    func testWritesMappedValue() throws {
        let mappedValue = "Hello world!"
        let mapper = DirectedGraphMapperMock(result: mappedValue)
        let writer = WriterMock()
        let obj = MappingDirectedGraphWriter(mapper: mapper, writer: writer)
        let graph = DirectedGraph()
        try obj.write(graph)
        XCTAssertEqual(writer.writtenValue, mappedValue)
    }
}
