import DirectedGraph
import XcodeProject

public protocol XcodeProjectGraphBuilder {
    func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph
}
