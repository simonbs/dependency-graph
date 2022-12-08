import DirectedGraph
import Foundation
import PackageSwiftFile
import PackageSwiftFileParser
import XcodeProject
import XcodeDependencyGraphBuilder

public enum XcodeDependencyGraphBuilderLiveError: LocalizedError {
    case dependencyNotFound(dendency: String, dependant: String)

    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(dependency, dependant):
            return "\(dependant) depends on \(dependency) but the dependency was not found in the graph."
        }
    }
}

public final class XcodeDependencyGraphBuilderLive: XcodeDependencyGraphBuilder {
    private let packageSwiftFileParser: PackageSwiftFileParser

    public init(packageSwiftFileParser: PackageSwiftFileParser) {
        self.packageSwiftFileParser = packageSwiftFileParser
    }

    public func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        let graph = DirectedGraph()
        for swiftPackage in xcodeProject.swiftPackages {
            try process(swiftPackage, into: graph)
        }
        let projectCluster = graph.addUniqueCluster(named: ClusterName.project(xcodeProject.name), labeled: xcodeProject.name)
        for target in xcodeProject.targets {
            let targetNode = projectCluster.addUniqueNode(named: NodeName.target(target.name), labeled: target.name)
            for dependency in target.packageProductDependencies {
                if let destinationNode = graph.node(named: NodeName.packageProduct(dependency)) {
                    graph.addEdge(from: targetNode, to: destinationNode)
                } else {
                    throw XcodeDependencyGraphBuilderLiveError.dependencyNotFound(dendency: dependency, dependant: target.name)
                }
            }
        }
        return graph
    }
}

private extension XcodeDependencyGraphBuilderLive {
    private func process(_ swiftPackage: XcodeProject.SwiftPackage, into graph: DirectedGraph) throws {
        switch swiftPackage {
        case .local(let parameters):
            let packageSwiftFile = try packageSwiftFileParser.parseFile(at: parameters.fileURL)
            process(packageSwiftFile, into: graph)
        case .remote(let parameters):
            let cluster = graph.addUniqueCluster(named: ClusterName.package(parameters.name), labeled: parameters.name)
            cluster.addUniqueNode(named: NodeName.packageProduct(parameters.name), labeled: parameters.name)
        }
    }

    private func process(_ packageSwiftFile: PackageSwiftFile, into graph: DirectedGraph) {
        let cluster = graph.addUniqueCluster(named: ClusterName.package(packageSwiftFile.name), labeled: packageSwiftFile.name)
        for product in packageSwiftFile.products {
            let productNode = cluster.addUniqueNode(named: NodeName.packageProduct(product.name), labeled: product.name)
            for target in product.targets {
                let targetNode = cluster.addUniqueNode(named: NodeName.target(target), labeled: target)
                graph.addEdge(from: productNode, to: targetNode)
            }
        }
        for target in packageSwiftFile.targets {
            cluster.addUniqueNode(named: NodeName.target(target.name), labeled: target.name)
        }
        for dependency in packageSwiftFile.dependencies {
            process(dependency, into: graph)
        }
    }

    private func process(_ dependency: PackageSwiftFile.Dependency, into graph: DirectedGraph) {
        switch dependency {
        case .fileSystem(let parameters):
            process(parameters.packageSwiftFile, into: graph)
        case .sourceControl:
            break
        }
    }
}
