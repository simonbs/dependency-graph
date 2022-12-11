import DirectedGraph
import DirectedGraphWriter

final class DirectedGraphWriterMock: DirectedGraphWriter {
    private(set) var didWrite = false

    func write(_ directedGraph: DirectedGraph) throws {
        didWrite = true
    }
}
