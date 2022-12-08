import Foundation

public extension DirectedGraph {
    final class Cluster: Equatable {
        public let name: String
        public let label: String
        public private(set) var nodes: [Node]

        public init(name: String, label: String, nodes: [Node] = []) {
            self.name = name
            self.label = label
            self.nodes = nodes
        }

        public func node(named name: String) -> Node? {
            return nodes.first { $0.name == name }
        }

        @discardableResult
        public func addUniqueNode(named name: String, labeled label: String) -> Node {
            if let node = node(named: name) {
                return node
            } else {
                let node = Node(name: name, label: label)
                nodes.append(node)
                return node
            }
        }

        public static func == (lhs: Cluster, rhs: Cluster) -> Bool {
            return lhs.label == rhs.label && lhs.nodes == rhs.nodes
        }
    }
}
