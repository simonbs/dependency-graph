import DirectedGraph

public protocol DirectedGraphMapper {
    associatedtype OutputType
    func map(_ graph: DirectedGraph) throws -> OutputType
}
