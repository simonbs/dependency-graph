import Foundation

public struct DOTGraphSettings {
    public let layout: String
    public let rankdir: String
    public let nodesep: Float?
    public let ranksep: Float?

    public init(nodesep: Float? = nil, ranksep: Float? = nil) {
        self.layout = "dot"
        self.rankdir = "LR"
        self.nodesep = nodesep
        self.ranksep = ranksep
    }
}

extension DOTGraphSettings {
    var stringRepresentation: String {
        var lines = [
            "layout=\(layout)",
            "rankdir=\(rankdir)"
        ]
        if let nodesep = nodesep {
            lines += ["nodesep=\(nodesep)"]
        }
        if let ranksep = ranksep {
            lines += ["ranksep=\(ranksep)"]
        }
        return lines.joined(separator: "\n")
    }
}
