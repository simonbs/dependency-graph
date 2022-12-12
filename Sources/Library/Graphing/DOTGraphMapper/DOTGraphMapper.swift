import DirectedGraph
import DirectedGraphMapper
import StringIndentHelpers

public struct DOTGraphMapper: DirectedGraphMapper {
    private let settings: DOTGraphSettings

    public init(settings: DOTGraphSettings = DOTGraphSettings()) {
        self.settings = settings
    }

    public func map(_ graph: DirectedGraph) throws -> String {
        return graph.stringRepresentation(withSetings: settings)
    }
}

extension DirectedGraph {
    func stringRepresentation(withSetings settings: DOTGraphSettings) -> String {
        var graphBodyLines: [String] = []
        graphBodyLines.append(settings.stringRepresentation)
        if !clusters.isEmpty {
            graphBodyLines.append(clusters.stringRepresentation)
        }
        if !nodes.isEmpty {
            graphBodyLines.append(nodes.stringRepresentation)
        }
        if !edges.isEmpty {
            graphBodyLines.append(edges.stringRepresentation)
        }
        let graphBody = graphBodyLines.indented.joined(separator: "\n\n")
        return ["digraph g {", graphBody, "}"].joined(separator: "\n")
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
        switch shape {
        case .ellipse:
            settings += ["shape=ellipse"]
        case .box:
            settings += ["shape=box"]
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

extension Array where Element == DirectedGraph.Node {
    var stringRepresentation: String {
        return map(\.stringRepresentation).joined(separator: "\n")
    }
}

extension Array where Element == DirectedGraph.Edge {
    var stringRepresentation: String {
        return map(\.stringRepresentation).joined(separator: "\n")
    }
}
