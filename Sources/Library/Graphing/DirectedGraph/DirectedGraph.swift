import Foundation

public final class DirectedGraph: Equatable {
    public private(set) var clusters: [Cluster]
    public private(set) var edges: [Edge]

    public init(clusters: [Cluster] = [], edges: [Edge] = []) {
        self.clusters = clusters
        self.edges = edges
    }

    @discardableResult
    public func addUniqueCluster(_ cluster: Cluster) -> Cluster {
        if let cluster = clusters.first(where: { $0.name == cluster.name }) {
            return cluster
        } else {
            clusters.append(cluster)
            return cluster
        }
    }

    @discardableResult
    public func addUniqueEdge(_ edge: Edge) -> Edge {
        if let edge = edges.first(where: { $0.sourceNode == edge.sourceNode && $0.destinationNode == edge.destinationNode }) {
            return edge
        } else {
            edges.append(edge)
            return edge
        }
    }

    public func node(named name: String) -> Node? {
        for cluster in clusters {
            if let node = cluster.node(named: name) {
                return node
            }
        }
        return nil
    }

    public func addSubgraph(_ graph: DirectedGraph) {
        for cluster in graph.clusters {
            addUniqueCluster(cluster)
        }
        for edge in graph.edges {
            addUniqueEdge(edge)
        }
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
            let nodesStrings = cluster.nodes.map { "          ○ \($0)" }
            return [clusterString, "        Nodes = ("] + nodesStrings + ["        )"]
        }
        lines += ["  )"]
        lines += ["  Edges = ("] + edges.map { "    - \($0)" } + ["  )"]
        lines += [")"]
        return lines.joined(separator: "\n")
    }
}
