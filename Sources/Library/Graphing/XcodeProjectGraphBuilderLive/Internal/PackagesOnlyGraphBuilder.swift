import DirectedGraph
import DirectedGraphXcodeHelpers
import Foundation
import PackageGraphBuilder
import PackageSwiftFile
import PackageSwiftFileParser
import XcodeProject
import XcodeProjectGraphBuilder

public struct PackagesOnlyGraphBuilder {
    private let packageSwiftFileParser: PackageSwiftFileParser
    private let packageGraphBuilder: PackageGraphBuilder

    public init(packageSwiftFileParser: PackageSwiftFileParser, packageGraphBuilder: PackageGraphBuilder) {
        self.packageSwiftFileParser = packageSwiftFileParser
        self.packageGraphBuilder = packageGraphBuilder
    }

    public func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        let graph = DirectedGraph()
        let node = graph.addUniqueNode(.project(labeled: xcodeProject.name))
        for swiftPackage in xcodeProject.swiftPackages {
            switch swiftPackage {
            case .local(let parameters):
                let packageSwiftFile = try packageSwiftFileParser.parseFile(at: parameters.fileURL)
                let childGraph = try packageGraphBuilder.buildGraph(from: packageSwiftFile)
                graph.union(childGraph)
                if let dependencyNode = graph.packageNode(labeled: parameters.name) {
                    graph.addUniqueEdge(.from(node, to: dependencyNode))
                } else {
                    throw XcodeProjectGraphBuilderLiveError.dependencyNotFound(dependency: parameters.name, dependant: xcodeProject.name)
                }
            case .remote(let parameters):
                let dependencyNode = graph.addUniqueNode(.package(labeled: parameters.name))
                graph.addUniqueEdge(.from(node, to: dependencyNode))
            }
        }
        return graph
    }
}
