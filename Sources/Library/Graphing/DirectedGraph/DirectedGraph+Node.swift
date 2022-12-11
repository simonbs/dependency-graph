import Foundation

public extension DirectedGraph {
    final class Node: Equatable {
        public let name: String
        public let label: String
        public let shape: String?

        public init(name: String, label: String, shape: String? = nil) {
            self.name = name
            self.label = label
            self.shape = shape
        }

        public static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.name == rhs.name && lhs.label == rhs.label && lhs.shape == rhs.shape
        }
    }
}
