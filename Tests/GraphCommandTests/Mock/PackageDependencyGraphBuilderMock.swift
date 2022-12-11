import DirectedGraph
import PackageDependencyGraphBuilder
import PackageSwiftFile

struct PackageDependencyGraphBuilderMock: PackageDependencyGraphBuilder {
    func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        return DirectedGraph()
    }
}
