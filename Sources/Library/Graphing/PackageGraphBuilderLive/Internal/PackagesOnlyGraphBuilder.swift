import DirectedGraph
import DirectedGraphXcodeHelpers
import PackageGraphBuilder
import PackageSwiftFile

struct PackagesOnlyGraphBuilder {
    static func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        let graph = DirectedGraph()
        let node = graph.addUniqueNode(.package(labeled: packageSwiftFile.name))
        for dependency in packageSwiftFile.dependencies {
            switch dependency {
            case .fileSystem(let parameters):
                let subgraph = try buildGraph(from: parameters.packageSwiftFile)
                graph.union(subgraph)
                if let dependencyNode = graph.packageNode(labeled: parameters.packageSwiftFile.name) {
                    graph.addUniqueEdge(.from(node, to: dependencyNode))
                } else {
                    throw PackageGraphBuilderLiveError.dependencyNotFound(
                        dependency: parameters.packageSwiftFile.name,
                        dependant: packageSwiftFile.name
                    )
                }
            case .sourceControl:
                break
            }
        }
        return graph
    }
}
