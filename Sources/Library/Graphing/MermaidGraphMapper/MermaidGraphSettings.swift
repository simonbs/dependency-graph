public struct MermaidGraphSettings {
    public let nodeSpacing: Int?
    public let rankSpacing: Int?

    public init(nodeSpacing: Int? = nil, rankSpacing: Int? = nil) {
        self.nodeSpacing = nodeSpacing
        self.rankSpacing = rankSpacing
    }
}

extension MermaidGraphSettings {
    var stringRepresentation: String {
        var flowchartSettings: [String] = []
        if let nodeSpacing = nodeSpacing {
            flowchartSettings += ["'nodeSpacing': \(nodeSpacing)"]
        }
        if let rankSpacing = rankSpacing {
            flowchartSettings += ["'rankSpacing': \(rankSpacing)"]
        }
        return "%%{init:{'flowchart':{\(flowchartSettings.joined(separator: ", "))}}}%%"
    }
}
