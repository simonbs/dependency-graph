public final class Node {
    public let name: String
    public private(set) var children: [Node]

    public init(name: String, children: [Node] = []) {
        self.name = name
        self.children = children
    }

    public func addChild(_ node: Node) {
        children.append(node)
    }
}
