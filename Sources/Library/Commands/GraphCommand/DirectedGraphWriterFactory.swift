import DirectedGraphWriter

public struct DirectedGraphWriterFactory {
    private let dotGraphWriter: any DirectedGraphWriter
    private let mermaidGraphWriter: any DirectedGraphWriter

    public init(dotGraphWriter: any DirectedGraphWriter, mermaidGraphWriter: any DirectedGraphWriter) {
        self.dotGraphWriter = dotGraphWriter
        self.mermaidGraphWriter = mermaidGraphWriter
    }

    func writer(for syntax: Syntax) -> any DirectedGraphWriter {
        switch syntax {
        case .dot:
            return dotGraphWriter
        case .mermaid:
            return mermaidGraphWriter
        }
    }
}
