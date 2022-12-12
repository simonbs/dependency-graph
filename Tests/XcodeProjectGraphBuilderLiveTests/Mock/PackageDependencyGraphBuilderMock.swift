import DirectedGraph
import Foundation
import PackageGraphBuilder
import PackageSwiftFile

private enum PackageGraphBuilderMockError: LocalizedError {
    case mockNotFound(PackageSwiftFile)

    var errorDescription: String? {
        switch self {
        case .mockNotFound(let packageSwiftFile):
            return "Mock not found for package \(packageSwiftFile.name)"
        }
    }
}

struct PackageGraphBuilderMock: PackageGraphBuilder {
    private let packagesOnly: Bool

    init(packagesOnly: Bool) {
        self.packagesOnly = packagesOnly
    }

    func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        switch packageSwiftFile.name {
        case "ExamplePackageA":
            return .examplePackageA(packagesOnly: packagesOnly)
        case "ExamplePackageB":
            return .examplePackageB(packagesOnly: packagesOnly)
        default:
            throw PackageGraphBuilderMockError.mockNotFound(packageSwiftFile)
        }
    }
}

private extension DirectedGraph {
    static func examplePackageA(packagesOnly: Bool) -> DirectedGraph {
        if packagesOnly {
            return DirectedGraph(nodes: [.package(labeled: "ExamplePackageA")])
        } else {
            let packageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryA")
            let targetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryA")
            let cluster: DirectedGraph.Cluster = .package(labeled: "ExamplePackageA", nodes: [packageProductNode, targetNode])
            return DirectedGraph(clusters: [cluster], edges: [.from(packageProductNode, to: targetNode)])
        }
    }

    static func examplePackageB(packagesOnly: Bool) -> DirectedGraph {
        if packagesOnly {
            return DirectedGraph(nodes: [.package(labeled: "ExamplePackageB")])
        } else {
            let packageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryB")
            let targetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryB")
            let cluster: DirectedGraph.Cluster = .package(labeled: "ExamplePackageB", nodes: [packageProductNode, targetNode])
            return DirectedGraph(clusters: [cluster], edges: [.from(packageProductNode, to: targetNode)])
        }
    }
}
