import DirectedGraph
import DOTGraphTransformer

public struct DOTGraphTransformerLive: DOTGraphTransformer {
    public init() {}

    public func transform(_ graph: DirectedGraph) throws -> String {
        let nodeSettings = DOTGraphSettings.Node(shape: "box")
        let settings = DOTGraphSettings(node: nodeSettings, layout: "dot")
        return graph.stringRepresentation(withSetings: settings)
    }
}

extension DirectedGraph {
    func stringRepresentation(withSetings settings: DOTGraphSettings) -> String {
        return [
            "digraph g {",
            [
                settings.stringRepresentation,
                clusters.stringRepresentation,
                edges.stringRepresentation
            ].indented.joined(separator: "\n\n"),
            "}"
        ].joined(separator: "\n")
    }
}

extension DirectedGraph.Cluster {
    var stringRepresentation: String {
        var lines = ["subgraph \(name) {"]
        lines += ["label=\"\(label)\""].indented
        lines += nodes.map(\.stringRepresentation).indented
        lines += ["}"]
        return lines.joined(separator: "\n")
    }
}

extension DirectedGraph.Node {
    var stringRepresentation: String {
        return name + " [label=\"\(label)\"]"
    }
}

extension DirectedGraph.Edge {
    var stringRepresentation: String {
        return "\(sourceNode.name) -> \(destinationNode.name)"
    }
}

extension Array where Element == DirectedGraph.Cluster {
    var stringRepresentation: String {
        return map(\.stringRepresentation).joined(separator: "\n\n")
    }
}

extension Array where Element == DirectedGraph.Edge {
    var stringRepresentation: String {
        return map(\.stringRepresentation).joined(separator: "\n")
    }
}
