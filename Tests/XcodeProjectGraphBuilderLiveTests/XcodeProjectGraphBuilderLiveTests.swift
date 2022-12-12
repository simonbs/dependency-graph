import DirectedGraph
@testable import XcodeProjectGraphBuilderLive
import XCTest

final class XcodeProjectGraphBuilderLiveTests: XCTestCase {
    // swiftlint:disable:next function_body_length
    func testBuildsGraphs() throws {
        let packageSwiftFileParser = PackageSwiftFileParserMock()
        let packageGraphBuilder = PackageGraphBuilderMock(packagesOnly: false)
        let graphBuilder = XcodeProjectGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser,
                                                        packageGraphBuilder: packageGraphBuilder,
                                                        packagesOnly: false)
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
            .from(exampleLibraryAPackageProductNode, to: exampleLibraryATargetNode),
            .from(exampleLibraryBPackageProductNode, to: exampleLibraryBTargetNode),
            .from(exampleTargetNode, to: exampleLibraryAPackageProductNode),
            .from(exampleTargetNode, to: exampleLibraryBPackageProductNode),
            .from(exampleTargetNode, to: remoteAPackageProductNode),
            .from(exampleTargetNode, to: remoteBFooPackageProductNode),
            .from(exampleTargetNode, to: remoteBBarPackageProductNode)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }

    func testThrowsWhenBuildingGraphWithMissingDependency() throws {
        let packageSwiftFileParser = PackageSwiftFileParserMock()
        let packageGraphBuilder = PackageGraphBuilderMock(packagesOnly: false)
        let graphBuilder = XcodeProjectGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser,
                                                        packageGraphBuilder: packageGraphBuilder,
                                                        packagesOnly: false)
        XCTAssertThrowsError(try graphBuilder.buildGraph(from: .mockWithMissingDependency))
    }

    func testBuildsGraphWithPackagesOnly() throws {
        let packageSwiftFileParser = PackageSwiftFileParserMock()
        let packageGraphBuilder = PackageGraphBuilderMock(packagesOnly: true)
        let graphBuilder = XcodeProjectGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser,
                                                        packageGraphBuilder: packageGraphBuilder,
                                                        packagesOnly: true)
        let graph = try graphBuilder.buildGraph(from: .mock)

        let nodeProject: DirectedGraph.Node = .project(labeled: "Example.xcodeproj")
        let nodePackageA: DirectedGraph.Node = .package(labeled: "ExamplePackageA")
        let nodePackageB: DirectedGraph.Node = .package(labeled: "ExamplePackageB")
        let nodeRemoteA: DirectedGraph.Node = .package(labeled: "RemoteA")
        let nodeRemoteB: DirectedGraph.Node = .package(labeled: "RemoteB")

        let expectedGraph = DirectedGraph(nodes: [
            nodeProject,
            nodePackageA,
            nodePackageB,
            nodeRemoteA,
            nodeRemoteB
        ], edges: [
            .from(nodeProject, to: nodePackageA),
            .from(nodeProject, to: nodePackageB),
            .from(nodeProject, to: nodeRemoteA),
            .from(nodeProject, to: nodeRemoteB)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }
}
