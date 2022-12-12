import DirectedGraph
import DirectedGraphXcodeHelpers
@testable import PackageGraphBuilderLive
import PackageSwiftFile
import XCTest

final class PackageGraphBuilderLiveTests: XCTestCase {
    func testParsesPackageWithNoDependencies() throws {
        let graphBuilder = PackageGraphBuilderLive(packagesOnly: false)
        let graph = try graphBuilder.buildGraph(from: .noDependenciesMock)
        let packageProductNode: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryA")
        let targetNode: DirectedGraph.Node = .target(labeled: "ExampleLibraryA")
        let expectedGraph = DirectedGraph(clusters: [
            .package(labeled: "ExamplePackageA", nodes: [
                packageProductNode,
                targetNode
            ])
        ], edges: [
            .from(packageProductNode, to: targetNode)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }

    func testParsesPackageWithDependencies() throws {
        let graphBuilder = PackageGraphBuilderLive(packagesOnly: false)
        let graph = try graphBuilder.buildGraph(from: .withDependenciesMock)

        let packageProductNodeA: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryA")
        let targetNodeA: DirectedGraph.Node = .target(labeled: "ExampleLibraryA")

        let packageProductNodeB: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryB")
        let targetNodeB: DirectedGraph.Node = .target(labeled: "ExampleLibraryB")
        let targetNodeBFoo: DirectedGraph.Node = .target(labeled: "ExampleLibraryBFoo")

        let packageProductNodeC: DirectedGraph.Node = .packageProduct(labeled: "ExampleLibraryC")
        let targetNodeC: DirectedGraph.Node = .target(labeled: "ExampleLibraryC")

        let expectedGraph = DirectedGraph(clusters: [
            .package(labeled: "ExamplePackageC", nodes: [
                packageProductNodeC,
                targetNodeC
            ]),
            .package(labeled: "ExamplePackageB", nodes: [
                packageProductNodeB,
                targetNodeB,
                targetNodeBFoo
            ]),
            .package(labeled: "ExamplePackageA", nodes: [
                packageProductNodeA,
                targetNodeA
            ])
        ], edges: [
            .from(packageProductNodeC, to: targetNodeC),
            .from(packageProductNodeB, to: targetNodeB),
            .from(targetNodeB, to: targetNodeBFoo),
            .from(targetNodeB, to: packageProductNodeC),
            .from(packageProductNodeA, to: targetNodeA),
            .from(targetNodeA, to: packageProductNodeB)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }

    func testBuildsGraphWithPackagesOnly() throws {
        let graphBuilder = PackageGraphBuilderLive(packagesOnly: true)
        let graph = try graphBuilder.buildGraph(from: .withDependenciesMock)
        let nodeA: DirectedGraph.Node = .package(labeled: "ExamplePackageA")
        let nodeB: DirectedGraph.Node = .package(labeled: "ExamplePackageB")
        let nodeC: DirectedGraph.Node = .package(labeled: "ExamplePackageC")
        let expectedGraph = DirectedGraph(nodes: [nodeA, nodeB, nodeC], edges: [
            .from(nodeB, to: nodeC),
            .from(nodeA, to: nodeB)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }
}
