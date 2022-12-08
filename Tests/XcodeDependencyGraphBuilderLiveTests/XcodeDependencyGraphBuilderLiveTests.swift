import DirectedGraph
@testable import XcodeDependencyGraphBuilderLive
import XCTest

final class XcodeDependencyGraphBuilderLiveTests: XCTestCase {
    func testBuildsGraphs() throws {
        let packageSwiftFileParser = PackageSwiftFileParserMock()
        let graphBuilder = XcodeDependencyGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser)
        let graph = try graphBuilder.buildGraph(from: .mock)

        let exampleLibraryAPackageProductNode = DirectedGraph.Node(name: NodeName.packageProduct("ExampleLibraryA"), label: "ExampleLibraryA")
        let exampleLibraryATargetNode = DirectedGraph.Node(name: NodeName.target("ExampleLibraryA"), label: "ExampleLibraryA")
        let examplePackageACluster = DirectedGraph.Cluster(name: ClusterName.package("ExamplePackageA"), label: "ExamplePackageA", nodes: [
            exampleLibraryAPackageProductNode,
            exampleLibraryATargetNode
        ])

        let exampleLibraryBPackageProductNode = DirectedGraph.Node(name: NodeName.packageProduct("ExampleLibraryB"), label: "ExampleLibraryB")
        let exampleLibraryBTargetNode = DirectedGraph.Node(name: NodeName.target("ExampleLibraryB"), label: "ExampleLibraryB")
        let examplePackageBCluster = DirectedGraph.Cluster(name: ClusterName.package("ExamplePackageB"), label: "ExamplePackageB", nodes: [
            exampleLibraryBPackageProductNode,
            exampleLibraryBTargetNode
        ])

        let remoteAPackageProductNode = DirectedGraph.Node(name: NodeName.packageProduct("RemoteA"), label: "RemoteA")
        let remoteAPackageCluster = DirectedGraph.Cluster(name: ClusterName.package("RemoteA"), label: "RemoteA", nodes: [
            remoteAPackageProductNode
        ])

        let remoteBFooPackageProductNode = DirectedGraph.Node(name: NodeName.packageProduct("RemoteBFoo"), label: "RemoteBFoo")
        let remoteBBarPackageProductNode = DirectedGraph.Node(name: NodeName.packageProduct("RemoteBBar"), label: "RemoteBBar")
        let remoteBPackageCluster = DirectedGraph.Cluster(name: ClusterName.package("RemoteB"), label: "RemoteB", nodes: [
            remoteBFooPackageProductNode,
            remoteBBarPackageProductNode
        ])

        let exampleTargetNode = DirectedGraph.Node(name: NodeName.target("Example"), label: "Example")
        let exampleTestsTargetNode = DirectedGraph.Node(name: NodeName.target("ExampleTests"), label: "ExampleTests")
        let exampleUITestsTargetNode = DirectedGraph.Node(name: NodeName.target("ExampleUITests"), label: "ExampleUITests")
        let projectCluster = DirectedGraph.Cluster(name: ClusterName.project("Example.xcodeproj"), label: "Example.xcodeproj", nodes: [
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
        let graphBuilder = XcodeDependencyGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser)
        XCTAssertThrowsError(try graphBuilder.buildGraph(from: .mockWithMissingDependency))
    }
}
