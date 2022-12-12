import DirectedGraph
import XcodeProject
import XcodeProjectGraphBuilder

struct XcodeProjectGraphBuilderMock: XcodeProjectGraphBuilder {
    func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        return DirectedGraph()
    }
}
