import DirectedGraph
import DirectedGraphMapper
import StringIndentHelpers

public struct MermaidGraphMapper: DirectedGraphMapper {
    public init() {}

    public func map(_ graph: DirectedGraph) throws -> String {
        return graph.stringRepresentation
    }
}

extension DirectedGraph {
    var stringRepresentation: String {
        return [
            "graph TB",
            [
                clusters.stringRepresentation,
                edges.stringRepresentation
            ].indented.joined(separator: "\n\n")
        ].joined(separator: "\n")
    }
}

extension DirectedGraph.Cluster {
    var stringRepresentation: String {
        var lines = ["subgraph \(name)[\(label)]"]
        lines += nodes.map(\.stringRepresentation).indented
        lines += ["end"]
        return lines.joined(separator: "\n")
    }
}

extension DirectedGraph.Node {
    var stringRepresentation: String {
        switch shape {
        case .box:
            return name + "[" + label + "]"
        case .ellipse:
            return name + "([" + label + "])"
        }
    }
}

extension DirectedGraph.Edge {
    var stringRepresentation: String {
        return "\(sourceNode.name) --> \(destinationNode.name)"
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
