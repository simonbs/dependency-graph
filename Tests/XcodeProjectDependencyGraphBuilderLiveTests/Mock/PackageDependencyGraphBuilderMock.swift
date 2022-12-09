import DirectedGraph
import Foundation
import PackageSwiftFile
import PackageDependencyGraphBuilder

private enum PackageDependencyGraphBuilderMockError: LocalizedError {
    case mockNotFound(PackageSwiftFile)

    var errorDescription: String? {
        switch self {
        case .mockNotFound(let packageSwiftFile):
            return "Mock not found for package \(packageSwiftFile.name)"
        }
    }
}

struct PackageDependencyGraphBuilderMock: PackageDependencyGraphBuilder {
    func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        switch packageSwiftFile.name {
        case "ExamplePackageA":
            return .examplePackageA
        case "ExamplePackageB":
            return .examplePackageB
        default:
            throw PackageDependencyGraphBuilderMockError.mockNotFound(packageSwiftFile)
        }
    }
}

private extension DirectedGraph {
    static var examplePackageA: DirectedGraph {
        let packageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryA")
        let targetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryA")
        let cluster: DirectedGraph.Cluster = .package(labeled: "ExamplePackageA", nodes: [packageProductNode, targetNode])
        return DirectedGraph(clusters: [cluster], edges: [.from(packageProductNode, to: targetNode)])
    }

    static var examplePackageB: DirectedGraph {
        let packageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryB")
        let targetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryB")
        let cluster: DirectedGraph.Cluster = .package(labeled: "ExamplePackageB", nodes: [packageProductNode, targetNode])
        return DirectedGraph(clusters: [cluster], edges: [.from(packageProductNode, to: targetNode)])
    }
}
