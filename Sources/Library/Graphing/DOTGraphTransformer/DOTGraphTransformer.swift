import DirectedGraph
import DirectedGraphTransformer
import StringIndentHelpers

public struct DOTGraphTransformer: DirectedGraphTransformer {
    public init() {}

    public func transform(_ graph: DirectedGraph) throws -> String {
        let settings = DOTGraphSettings(layout: "dot")
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
        var lines = ["subgraph cluster_\(name) {"]
        lines += ["label=\"\(label)\""].indented
        lines += nodes.map(\.stringRepresentation).indented
        lines += ["}"]
        return lines.joined(separator: "\n")
    }
}

extension DirectedGraph.Node {
    var stringRepresentation: String {
        var settings: [String] = ["label=\"\(label)\""]
        if let shape = shape {
            settings += ["shape=\(shape)"]
        }
        return name + " [" + settings.joined(separator: ", ") + "]"
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
