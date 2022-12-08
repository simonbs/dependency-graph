import Foundation

public extension DirectedGraph {
    final class Edge: Equatable {
        public let sourceNode: Node
        public let destinationNode: Node

        public init(from sourceNode: Node, to destinationNode: Node) {
            self.sourceNode = sourceNode
            self.destinationNode = destinationNode
        }

        public static func == (lhs: Edge, rhs: Edge) -> Bool {
            return lhs.sourceNode == rhs.sourceNode && lhs.destinationNode == rhs.destinationNode
        }
    }
}
