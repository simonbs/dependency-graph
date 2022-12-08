import Foundation

public extension DirectedGraph {
    final class Node: Equatable {
        public let name: String
        public let label: String

        public init(name: String, label: String) {
            self.name = name
            self.label = label
        }

        public static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.name == rhs.name && lhs.label == rhs.label
        }
    }
}
