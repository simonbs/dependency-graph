import Foundation

public final class DirectedGraph: Equatable {
    public private(set) var clusters: [Cluster]
    public private(set) var edges: [Edge]

    public init(clusters: [Cluster] = [], edges: [Edge] = []) {
        self.clusters = clusters
        self.edges = edges
    }

    @discardableResult
    public func addUniqueCluster(named name: String, labeled label: String) -> Cluster {
        if let cluster = clusters.first(where: { $0.name == name }) {
            return cluster
        } else {
            let cluster = Cluster(name: name, label: label)
            clusters.append(cluster)
            return cluster
        }
    }

    @discardableResult
    public func addEdge(from sourceNode: Node, to destinationNode: Node) -> Edge {
        let edge = Edge(from: sourceNode, to: destinationNode)
        edges.append(edge)
        return edge
    }

    public func node(named name: String) -> Node? {
        for cluster in clusters {
            if let node = cluster.node(named: name) {
                return node
            }
        }
        return nil
    }

    public static func == (lhs: DirectedGraph, rhs: DirectedGraph) -> Bool {
        return lhs.clusters == rhs.clusters
    }
}

extension DirectedGraph: CustomDebugStringConvertible {
    public var debugDescription: String {
        var lines = ["DirectedGraph = ("]
        lines += ["  Clusters = ("] + clusters.flatMap { cluster in
            let clusterString = "    □ \(cluster.label) (\(cluster.name))"
            let nodesStrings = cluster.nodes.map { "          ○ \($0.label) (\($0.name))" }
            return [clusterString, "        Nodes = ("] + nodesStrings + ["        )"]
        }
        lines += ["  )"]
        lines += ["  Edges = ("] + edges.map { "    - \($0.sourceNode.name) ⟶ \($0.destinationNode.name)" } + ["  )"]
        lines += [")"]
        return lines.joined(separator: "\n")
    }
}
