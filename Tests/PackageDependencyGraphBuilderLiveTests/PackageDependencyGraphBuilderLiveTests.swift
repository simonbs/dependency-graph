import DirectedGraph
import DirectedGraphXcodeHelpers
@testable import PackageDependencyGraphBuilderLive
import PackageSwiftFile
import XCTest

final class PackageDependencyGraphBuilderLiveTests: XCTestCase {
    func testParsesPackageWithNoDependencies() throws {
        let extractedExpr = PackageDependencyGraphBuilderLive()
        let graphBuilder = extractedExpr
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
        let graphBuilder = PackageDependencyGraphBuilderLive()
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
            .from(packageProductNodeA, to: targetNodeA),
            .from(packageProductNodeA, to: packageProductNodeB),
            .from(packageProductNodeB, to: targetNodeB),
            .from(targetNodeB, to: targetNodeBFoo),
            .from(targetNodeB, to: packageProductNodeC),
            .from(packageProductNodeC, to: targetNodeC)
        ])
        XCTAssertEqual(graph, expectedGraph)
    }
}
