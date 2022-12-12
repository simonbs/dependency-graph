import DirectedGraph
import PackageGraphBuilder
import PackageSwiftFile

struct PackageGraphBuilderMock: PackageGraphBuilder {
    func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        return DirectedGraph()
    }
}
