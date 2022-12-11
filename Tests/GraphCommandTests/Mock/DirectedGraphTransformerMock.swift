import DirectedGraph
import DirectedGraphTransformer

final class DirectedGraphTransformerMock: DirectedGraphTransformer {
    private(set) var didTransform = false

    func transform(_ graph: DirectedGraph) throws -> String {
        didTransform = true
        return ""
    }
}
