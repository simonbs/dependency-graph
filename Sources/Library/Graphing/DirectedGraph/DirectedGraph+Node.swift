import Foundation

public extension DirectedGraph {
    final class Node: Equatable {
        public enum Shape {
            case box
            case ellipse
        }

        public let name: String
        public let label: String
        public let shape: Shape

        public init(name: String, label: String, shape: Shape = .box) {
            self.name = name
            self.label = label
            self.shape = shape
        }

        public static func == (lhs: Node, rhs: Node) -> Bool {
            return lhs.name == rhs.name && lhs.label == rhs.label && lhs.shape == rhs.shape
        }
    }
}

extension DirectedGraph.Node: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(name) [label=\(label), shape=\(shape.title)]"
    }
}

private extension DirectedGraph.Node.Shape {
    var title: String {
        switch self {
        case .box:
            return "box"
        case .ellipse:
            return "ellipse"
        }
    }
}
