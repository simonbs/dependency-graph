import DirectedGraph
import DirectedGraphXcodeHelpers
import Foundation
import PackageGraphBuilder
import PackageSwiftFile
import PackageSwiftFileParser
import XcodeProject
import XcodeProjectGraphBuilder

public struct AllDependenciesGraphBuilder {
    private let packageSwiftFileParser: PackageSwiftFileParser
    private let packageGraphBuilder: PackageGraphBuilder

    public init(packageSwiftFileParser: PackageSwiftFileParser, packageGraphBuilder: PackageGraphBuilder) {
        self.packageSwiftFileParser = packageSwiftFileParser
        self.packageGraphBuilder = packageGraphBuilder
    }

    public func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        let graph = DirectedGraph()
        for swiftPackage in xcodeProject.swiftPackages {
            try process(swiftPackage, into: graph)
        }
        let projectCluster = graph.addProjectCluster(labeled: xcodeProject.name)
        for target in xcodeProject.targets {
            let targetNode = projectCluster.addUniqueNode(.target(labeled: target.name))
            for dependency in target.packageProductDependencies {
                if let destinationNode = graph.packageProductNode(labeled: dependency) {
                    graph.addUniqueEdge(.from(targetNode, to: destinationNode))
                } else {
                    throw XcodeProjectGraphBuilderLiveError.dependencyNotFound(dependency: dependency, dependant: target.name)
                }
            }
        }
        return graph
    }
}

private extension AllDependenciesGraphBuilder {
    private func process(_ swiftPackage: XcodeProject.SwiftPackage, into graph: DirectedGraph) throws {
        switch swiftPackage {
        case .local(let parameters):
            let packageSwiftFile = try packageSwiftFileParser.parseFile(at: parameters.fileURL)
            let childGraph = try packageGraphBuilder.buildGraph(from: packageSwiftFile)
            graph.union(childGraph)
        case .remote(let parameters):
            let cluster = graph.addPackageCluster(labeled: parameters.name)
            for product in parameters.products {
                cluster.addUniqueNode(.packageProduct(labeled: product))
            }
        }
    }
}
