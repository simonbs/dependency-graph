import DirectedGraph
import DirectedGraphMapper
import DirectedGraphWriter
import Writer

public struct MappingDirectedGraphWriter: DirectedGraphWriter {
    private let _write: (DirectedGraph) throws -> Void

    public init<M: DirectedGraphMapper, W: Writer>(mapper: M, writer: W) where M.OutputType == W.Input {
        _write = { try writer.write(try mapper.map($0)) }
    }

    public func write(_ directedGraph: DirectedGraph) throws {
        try _write(directedGraph)
    }
}
