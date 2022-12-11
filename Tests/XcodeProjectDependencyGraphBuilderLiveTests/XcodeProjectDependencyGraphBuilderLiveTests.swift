import DirectedGraph
@testable import XcodeProjectDependencyGraphBuilderLive
import XCTest

final class XcodeProjectDependencyGraphBuilderLiveTests: XCTestCase {
    // swiftlint:disable:next function_body_length
    func testBuildsGraphs() throws {
        let packageSwiftFileParser = PackageSwiftFileParserMock()
        let packageDependencyGraphBuilder = PackageDependencyGraphBuilderMock()
        let graphBuilder = XcodeProjectDependencyGraphBuilderLive(
            packageSwiftFileParser: packageSwiftFileParser,
            packageDependencyGraphBuilder: packageDependencyGraphBuilder
        )
        let graph = try graphBuilder.buildGraph(from: .mock)

        let exampleLibraryAPackageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryA")
        let exampleLibraryATargetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryA")
        let examplePackageACluster: DirectedGraph.Cluster = .package(labeled: "ExamplePackageA", nodes: [
            exampleLibraryAPackageProductNode,
            exampleLibraryATargetNode
        ])

        let exampleLibraryBPackageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryB")
        let exampleLibraryBTargetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryB")
        let examplePackageBCluster: DirectedGraph.Cluster = .package(labeled: "ExamplePackageB", nodes: [
            exampleLibraryBPackageProductNode,
            exampleLibraryBTargetNode
        ])

        let remoteAPackageProductNode: DirectedGraph.Node = .packageProduct(labeled: "RemoteA")
        let remoteAPackageCluster: DirectedGraph.Cluster = .package(labeled: "RemoteA", nodes: [
            remoteAPackageProductNode
        ])

        let remoteBFooPackageProductNode: DirectedGraph.Node = .packageProduct(labeled: "RemoteBFoo")
        let remoteBBarPackageProductNode: DirectedGraph.Node = .packageProduct(labeled: "RemoteBBar")
        let remoteBPackageCluster: DirectedGraph.Cluster = .package(labeled: "RemoteB", nodes: [
            remoteBFooPackageProductNode,
            remoteBBarPackageProductNode
        ])

        let exampleTargetNode: DirectedGraph.Node = .target(labeled: "Example")
        let exampleTestsTargetNode: DirectedGraph.Node = .target(labeled: "ExampleTests")
        let exampleUITestsTargetNode: DirectedGraph.Node = .target(labeled: "ExampleUITests")
        let projectCluster: DirectedGraph.Cluster = .project(labeled: "Example.xcodeproj", nodes: [
            exampleTargetNode,
            exampleTestsTargetNode,
            exampleUITestsTargetNode
        ])

        let expectedGraph = DirectedGraph(clusters: [
            examplePackageACluster,
            examplePackageBCluster,
            remoteAPackageCluster,
            remoteBPackageCluster,
            projectCluster
        ], edges: [
            DirectedGraph.Edge(from: exampleLibraryAPackageProductNode, to: exampleLibraryATargetNode),
            DirectedGraph.Edge(from: exampleLibraryBPackageProductNode, to: exampleLibraryBTargetNode),
            DirectedGraph.Edge(from: exampleTargetNode, to: exampleLibraryAPackageProductNode),
            DirectedGraph.Edge(from: exampleTargetNode, to: exampleLibraryBPackageProductNode),
            DirectedGraph.Edge(from: exampleTargetNode, to: remoteAPackageProductNode),
            DirectedGraph.Edge(from: exampleTargetNode, to: remoteBFooPackageProductNode),
            DirectedGraph.Edge(from: exampleTargetNode, to: remoteBBarPackageProductNode)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }

    func testThrowsWhenBuildingGraphWithMissingDependency() throws {
        let packageSwiftFileParser = PackageSwiftFileParserMock()
        let packageDependencyGraphBuilder = PackageDependencyGraphBuilderMock()
        let graphBuilder = XcodeProjectDependencyGraphBuilderLive(
            packageSwiftFileParser: packageSwiftFileParser,
            packageDependencyGraphBuilder: packageDependencyGraphBuilder
        )
        XCTAssertThrowsError(try graphBuilder.buildGraph(from: .mockWithMissingDependency))
    }
}
