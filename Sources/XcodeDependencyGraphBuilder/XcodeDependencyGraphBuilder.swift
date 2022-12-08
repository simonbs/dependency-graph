import DirectedGraph
import XcodeProject

public protocol XcodeDependencyGraphBuilder {
    func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph
}
