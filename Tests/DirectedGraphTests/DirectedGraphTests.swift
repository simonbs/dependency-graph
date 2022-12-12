@testable import DirectedGraph
import XCTest

final class DirectedGraphTests: XCTestCase {
    func testUnioningGraphsWithClusters() {
        let graphA_nodeA = DirectedGraph.Node(name: "NodeA", label: "NodeA", shape: .box)
        let graphA_nodeB = DirectedGraph.Node(name: "NodeB", label: "NodeB", shape: .box)
        let graphA_nodeC = DirectedGraph.Node(name: "NodeC", label: "NodeC", shape: .box)
        let graphA_clusterA = DirectedGraph.Cluster(name: "ClusterA", label: "ClusterA", nodes: [graphA_nodeA, graphA_nodeB])
        let graphA_clusterB = DirectedGraph.Cluster(name: "ClusterB", label: "ClusterB", nodes: [graphA_nodeC])
        let graphA_edge1: DirectedGraph.Edge = .from(graphA_nodeA, to: graphA_nodeB)
        let graphA_edge2: DirectedGraph.Edge = .from(graphA_nodeB, to: graphA_nodeC)
        let graphA = DirectedGraph(clusters: [graphA_clusterA, graphA_clusterB], edges: [graphA_edge1, graphA_edge2])

        let graphB_nodeA = DirectedGraph.Node(name: "NodeA", label: "NodeA", shape: .box)
        let graphB_nodeD = DirectedGraph.Node(name: "NodeD", label: "NodeD", shape: .box)
        let graphB_nodeE = DirectedGraph.Node(name: "NodeE", label: "NodeE", shape: .box)
        let graphB_clusterA = DirectedGraph.Cluster(name: "ClusterA", label: "ClusterA", nodes: [graphB_nodeA])
        let graphB_clusterB = DirectedGraph.Cluster(name: "ClusterB", label: "ClusterB", nodes: [graphB_nodeD])
        let graphB_clusterC = DirectedGraph.Cluster(name: "ClusterC", label: "ClusterC", nodes: [graphB_nodeE])
        let graphB_edge1: DirectedGraph.Edge = .from(graphB_nodeA, to: graphB_nodeD)
        let graphB_edge2: DirectedGraph.Edge = .from(graphB_nodeD, to: graphB_nodeE)
        let graphB = DirectedGraph(clusters: [graphB_clusterA, graphB_clusterB, graphB_clusterC], edges: [graphB_edge1, graphB_edge2])

        graphA.union(graphB)

        let expectedGraph_nodeA = DirectedGraph.Node(name: "NodeA", label: "NodeA", shape: .box)
        let expectedGraph_nodeB = DirectedGraph.Node(name: "NodeB", label: "NodeB", shape: .box)
        let expectedGraph_nodeC = DirectedGraph.Node(name: "NodeC", label: "NodeC", shape: .box)
        let expectedGraph_nodeD = DirectedGraph.Node(name: "NodeD", label: "NodeD", shape: .box)
        let expectedGraph_nodeE = DirectedGraph.Node(name: "NodeE", label: "NodeE", shape: .box)
        let expectedGraph_clusterA = DirectedGraph.Cluster(name: "ClusterA", label: "ClusterA", nodes: [graphA_nodeA, graphA_nodeB])
        let expectedGraph_clusterB = DirectedGraph.Cluster(name: "ClusterB", label: "ClusterB", nodes: [graphA_nodeC, expectedGraph_nodeD])
        let expectedGraph_clusterC = DirectedGraph.Cluster(name: "ClusterC", label: "ClusterC", nodes: [expectedGraph_nodeE])
        let expectedGraph_edge1: DirectedGraph.Edge = .from(expectedGraph_nodeA, to: expectedGraph_nodeB)
        let expectedGraph_edge2: DirectedGraph.Edge = .from(expectedGraph_nodeB, to: expectedGraph_nodeC)
        let expectedGraph_edge3: DirectedGraph.Edge = .from(expectedGraph_nodeA, to: expectedGraph_nodeD)
        let expectedGraph_edge4: DirectedGraph.Edge = .from(expectedGraph_nodeD, to: expectedGraph_nodeE)

        let expectedGraph = DirectedGraph(clusters: [
            expectedGraph_clusterA,
            expectedGraph_clusterB,
            expectedGraph_clusterC
        ], edges: [
            expectedGraph_edge1,
            expectedGraph_edge2,
            expectedGraph_edge3,
            expectedGraph_edge4
        ])
        XCTAssertEqual(graphA, expectedGraph)
    }

    func testUnioningGraphsWithRootNodes() {
        let graphA_nodeA = DirectedGraph.Node(name: "NodeA", label: "NodeA", shape: .box)
        let graphA_nodeB = DirectedGraph.Node(name: "NodeB", label: "NodeB", shape: .box)
        let graphA_nodeC = DirectedGraph.Node(name: "NodeC", label: "NodeC", shape: .box)
        let graphA_edge1: DirectedGraph.Edge = .from(graphA_nodeA, to: graphA_nodeB)
        let graphA_edge2: DirectedGraph.Edge = .from(graphA_nodeB, to: graphA_nodeC)
        let graphA = DirectedGraph(nodes: [graphA_nodeA, graphA_nodeB, graphA_nodeC], edges: [graphA_edge1, graphA_edge2])

        let graphB_nodeA = DirectedGraph.Node(name: "NodeA", label: "NodeA", shape: .box)
        let graphB_nodeD = DirectedGraph.Node(name: "NodeD", label: "NodeD", shape: .box)
        let graphB_nodeE = DirectedGraph.Node(name: "NodeE", label: "NodeE", shape: .box)
        let graphB_edge1: DirectedGraph.Edge = .from(graphB_nodeA, to: graphB_nodeD)
        let graphB_edge2: DirectedGraph.Edge = .from(graphB_nodeD, to: graphB_nodeE)
        let graphB = DirectedGraph(nodes: [graphB_nodeA, graphB_nodeD, graphB_nodeE], edges: [graphB_edge1, graphB_edge2])

        graphA.union(graphB)

        let expectedGraph_nodeA = DirectedGraph.Node(name: "NodeA", label: "NodeA", shape: .box)
        let expectedGraph_nodeB = DirectedGraph.Node(name: "NodeB", label: "NodeB", shape: .box)
        let expectedGraph_nodeC = DirectedGraph.Node(name: "NodeC", label: "NodeC", shape: .box)
        let expectedGraph_nodeD = DirectedGraph.Node(name: "NodeD", label: "NodeD", shape: .box)
        let expectedGraph_nodeE = DirectedGraph.Node(name: "NodeE", label: "NodeE", shape: .box)
        let expectedGraph_edge1: DirectedGraph.Edge = .from(expectedGraph_nodeA, to: expectedGraph_nodeB)
        let expectedGraph_edge2: DirectedGraph.Edge = .from(expectedGraph_nodeB, to: expectedGraph_nodeC)
        let expectedGraph_edge3: DirectedGraph.Edge = .from(expectedGraph_nodeA, to: expectedGraph_nodeD)
        let expectedGraph_edge4: DirectedGraph.Edge = .from(expectedGraph_nodeD, to: expectedGraph_nodeE)

        let expectedGraph = DirectedGraph(nodes: [
            expectedGraph_nodeA,
            expectedGraph_nodeB,
            expectedGraph_nodeC,
            expectedGraph_nodeD,
            expectedGraph_nodeE
        ], edges: [
            expectedGraph_edge1,
            expectedGraph_edge2,
            expectedGraph_edge3,
            expectedGraph_edge4
        ])
        XCTAssertEqual(graphA, expectedGraph)
    }
}
