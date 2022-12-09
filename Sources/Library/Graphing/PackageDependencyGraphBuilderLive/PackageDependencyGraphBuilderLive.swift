import DirectedGraph
import DirectedGraphXcodeHelpers
import PackageDependencyGraphBuilder
import PackageSwiftFile

public struct PackageDependencyGraphBuilderLive: PackageDependencyGraphBuilder {
    public init() {}

    public func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        let dependencyGraphs = try packageSwiftFile.dependencies.compactMap(graph(from:))
        let graph = DirectedGraph()
        for dependencyGraph in dependencyGraphs {
            graph.addSubgraph(dependencyGraph)
        }
        let cluster = graph.addPackageCluster(labeled: packageSwiftFile.name)
        for product in packageSwiftFile.products {
            let productNode = cluster.addPackageProductNode(labeled: product.name)
            for target in product.targets {
                let targetNode = cluster.addTargetNode(labeled: target)
                graph.addUniqueEdge(.from(productNode, to: targetNode))
            }
        }
        for target in packageSwiftFile.targets {
            let targetNode = cluster.addTargetNode(labeled: target.name)
            for dependency in target.dependencies {
                switch dependency {
                case .name(let parameters):
                    if let dependencyTargetNode = dependencyGraphs.findNode({ $0.targetNode(labeled: parameters.name) }) {
                        graph.addUniqueEdge(.from(targetNode, to: dependencyTargetNode))
                    } else {
                        let dependencyTargetNode = cluster.addTargetNode(labeled: parameters.name)
                        graph.addUniqueEdge(.from(targetNode, to: dependencyTargetNode))
                    }
                case .productInPackage(let parameters):
                    let packageClusterNode = graph.addPackageCluster(labeled: parameters.packageName)
                    let dependencyProductNode = packageClusterNode.addPackageProductNode(labeled: parameters.name)
                    graph.addUniqueEdge(.from(targetNode, to: dependencyProductNode))
                }
            }
        }
        return graph
    }
}

private extension PackageDependencyGraphBuilderLive {
    private func graph(from dependency: PackageSwiftFile.Dependency) throws -> DirectedGraph? {
        switch dependency {
        case .fileSystem(let parameters):
            return try buildGraph(from: parameters.packageSwiftFile)
        case .sourceControl:
            return nil
        }
    }
}

private extension Array where Element == DirectedGraph {
    func findNode(_ f: (DirectedGraph) -> DirectedGraph.Node?) -> DirectedGraph.Node? {
        for graph in self {
            if let node = f(graph) {
                return node
            }
        }
        return nil
    }
}
