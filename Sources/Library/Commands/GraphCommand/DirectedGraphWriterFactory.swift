import DirectedGraphWriter

public struct DirectedGraphWriterFactory {
    private let d2GraphWriter: any DirectedGraphWriter
    private let dotGraphWriter: any DirectedGraphWriter
    private let mermaidGraphWriter: any DirectedGraphWriter

    public init(d2GraphWriter: any DirectedGraphWriter, dotGraphWriter: any DirectedGraphWriter, mermaidGraphWriter: any DirectedGraphWriter) {
        self.d2GraphWriter = d2GraphWriter
        self.dotGraphWriter = dotGraphWriter
        self.mermaidGraphWriter = mermaidGraphWriter
    }

    func writer(for syntax: Syntax) -> any DirectedGraphWriter {
        switch syntax {
        case .d2:
            return d2GraphWriter
        case .dot:
            return dotGraphWriter
        case .mermaid:
            return mermaidGraphWriter
        }
    }
}
