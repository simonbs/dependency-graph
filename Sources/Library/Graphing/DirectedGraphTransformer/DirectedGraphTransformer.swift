import DirectedGraph

public protocol DirectedGraphTransformer {
    func transform(_ graph: DirectedGraph) throws -> String
}
