import DirectedGraph
import XcodeProject

public protocol XcodeProjectDependencyGraphBuilder {
    func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph
}
