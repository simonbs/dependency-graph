import DirectedGraphTransformer

public struct DirectedGraphTransformerFactory {
    private let dotGraphTransformer: DirectedGraphTransformer
    private let mermaidGraphTransformer: DirectedGraphTransformer

    public init(dotGraphTransformer: DirectedGraphTransformer, mermaidGraphTransformer: DirectedGraphTransformer) {
        self.dotGraphTransformer = dotGraphTransformer
        self.mermaidGraphTransformer = mermaidGraphTransformer
    }

    func transformer(for syntax: Syntax) -> DirectedGraphTransformer {
        switch syntax {
        case .dot:
            return dotGraphTransformer
        case .mermaid:
            return mermaidGraphTransformer
        }
    }
}
