import DirectedGraph
import DirectedGraphXcodeHelpers
import Foundation
import PackageDependencyGraphBuilder
import PackageSwiftFile
import PackageSwiftFileParser
import XcodeProjectDependencyGraphBuilder
import XcodeProject

public enum XcodeProjectDependencyGraphBuilderLiveError: LocalizedError {
    case dependencyNotFound(dependency: String, dependant: String)

    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(dependency, dependant):
            return "\(dependant) depends on \(dependency) but the dependency was not found in the graph."
        }
    }
}

public final class XcodeProjectDependencyGraphBuilderLive: XcodeProjectDependencyGraphBuilder {
    private let packageSwiftFileParser: PackageSwiftFileParser
    private let packageDependencyGraphBuilder: PackageDependencyGraphBuilder

    public init(packageSwiftFileParser: PackageSwiftFileParser, packageDependencyGraphBuilder: PackageDependencyGraphBuilder) {
        self.packageSwiftFileParser = packageSwiftFileParser
        self.packageDependencyGraphBuilder = packageDependencyGraphBuilder
    }

    public func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        let graph = DirectedGraph()
        for swiftPackage in xcodeProject.swiftPackages {
            try process(swiftPackage, into: graph)
        }
        let projectCluster = graph.addProjectCluster(labeled: xcodeProject.name)
        for target in xcodeProject.targets {
            let targetNode = projectCluster.addTargetNode(labeled: target.name)
            for dependency in target.packageProductDependencies {
                if let destinationNode = graph.packageProductNode(labeled: dependency) {
                    graph.addUniqueEdge(.from(targetNode, to: destinationNode))
                } else {
                    throw XcodeProjectDependencyGraphBuilderLiveError.dependencyNotFound(
                        dependency: dependency,
                        dependant: target.name
                    )
                }
            }
        }
        return graph
    }
}

private extension XcodeProjectDependencyGraphBuilderLive {
    private func process(_ swiftPackage: XcodeProject.SwiftPackage, into graph: DirectedGraph) throws {
        switch swiftPackage {
        case .local(let parameters):
            let packageSwiftFile = try packageSwiftFileParser.parseFile(at: parameters.fileURL)
            let childGraph = try packageDependencyGraphBuilder.buildGraph(from: packageSwiftFile)
            graph.addSubgraph(childGraph)
        case .remote(let parameters):
            let cluster = graph.addPackageCluster(labeled: parameters.name)
            for product in parameters.products {
                cluster.addPackageProductNode(labeled: product)
            }
        }
    }
}
