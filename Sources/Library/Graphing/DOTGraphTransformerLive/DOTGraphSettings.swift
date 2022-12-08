import Foundation

struct DOTGraphSettings {
    struct Node {
        let shape: String
    }

    let node: Node
    let layout: String
}

extension DOTGraphSettings {
    var stringRepresentation: String {
        return [
            node.stringRepresentation,
            "layout=\(layout)"
        ].joined(separator: "\n\n")
    }
}

extension DOTGraphSettings.Node {
    var stringRepresentation: String {
        return [
            "node [",
            "shape=\(shape)".indented,
            "]"
        ].joined(separator: "\n")
    }
}
