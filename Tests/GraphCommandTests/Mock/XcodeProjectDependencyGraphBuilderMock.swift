import DirectedGraph
import XcodeProject
import XcodeProjectDependencyGraphBuilder

struct XcodeProjectDependencyGraphBuilderMock: XcodeProjectDependencyGraphBuilder {
    func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        return DirectedGraph()
    }
}
