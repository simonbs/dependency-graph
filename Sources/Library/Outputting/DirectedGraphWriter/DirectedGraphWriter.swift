import DirectedGraph
import Writer

public protocol DirectedGraphWriter: Writer {
    func write(_ directedGraph: DirectedGraph) throws
}
