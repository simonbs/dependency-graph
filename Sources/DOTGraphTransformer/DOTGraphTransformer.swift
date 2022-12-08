import DirectedGraph

public protocol DOTGraphTransformer {
    func transform(_ graph: DirectedGraph) throws -> String
}
