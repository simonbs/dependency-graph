import DirectedGraph
import DirectedGraphMapper
import Foundation
import StringIndentHelpers

enum D2GraphMapperError: LocalizedError {
    case failedFindingClusterContainingNode(DirectedGraph.Node)

    var errorDescription: String? {
        switch self {
        case .failedFindingClusterContainingNode(let node):
            return "Could not find cluster containing node named '\(node.name)'"
        }
    }
}

public struct D2GraphMapper: DirectedGraphMapper {
    private let settings = D2GraphSettings()

    public init() {}

    public func map(_ graph: DirectedGraph) throws -> String {
        return try graph.stringRepresentation(withSettings: settings)
    }
}

extension DirectedGraph {
    func stringRepresentation(withSettings settings: D2GraphSettings) throws -> String {
        var lines: [String] = []
        lines.append(settings.stringRepresentation)
        if !clusters.isEmpty {
            lines.append(clusters.stringRepresentation)
        }
        if !nodes.isEmpty {
            lines.append(nodes.stringRepresentation)
        }
        if !edges.isEmpty {
            lines.append(try edges.stringRepresentation(in: self))
        }
        return lines.joined(separator: "\n\n")
    }
}

extension DirectedGraph.Cluster {
    var stringRepresentation: String {
        var lines = ["\(name): \(label) {"]
        lines += nodes.map(\.stringRepresentation).indented
        lines += ["}"]
        return lines.joined(separator: "\n")
    }
}

extension DirectedGraph.Node {
    var stringRepresentation: String {
        var lines = [name + ": " + label]
        switch shape {
        case .box:
            lines += [name + ".shape: rectangle"]
        case .ellipse:
            lines += [name + ".shape: oval"]
        }
        return lines.joined(separator: "\n")
    }
}

extension DirectedGraph.Edge {
    func stringRepresentation(in graph: DirectedGraph) throws -> String {
        func path(for node: DirectedGraph.Node) throws -> String {
            guard !graph.isRootNode(node) else {
                return node.name
            }
            guard let cluster = graph.cluster(containing: node) else {
                throw D2GraphMapperError.failedFindingClusterContainingNode(node)
            }
//            print(cluster.name + "." + node.name)
            return cluster.name + "." + node.name
        }
        return "\(try path(for: sourceNode)) -> \(try path(for: destinationNode))"
    }
}

extension Array where Element == DirectedGraph.Cluster {
    var stringRepresentation: String {
        return map { $0.stringRepresentation }.joined(separator: "\n\n")
    }
}

extension Array where Element == DirectedGraph.Node {
    var stringRepresentation: String {
        return map(\.stringRepresentation).joined(separator: "\n")
    }
}

extension Array where Element == DirectedGraph.Edge {
    func stringRepresentation(in graph: DirectedGraph) throws -> String {
        return try map { try $0.stringRepresentation(in: graph) }.joined(separator: "\n")
    }
}

private extension DirectedGraph {
    func isRootNode(_ node: DirectedGraph.Node) -> Bool {
        return nodes.contains(node)
    }

    func cluster(containing node: DirectedGraph.Node) -> DirectedGraph.Cluster? {
        return clusters.first { cluster in
            return cluster.nodes.contains { $0.name == node.name }
        }
    }
}
