import DirectedGraph
import DirectedGraphMapper

final class DirectedGraphMapperMock: DirectedGraphMapper {
    private(set) var didMap = false

    func map(_ graph: DirectedGraph) throws -> String {
        didMap = true
        return ""
    }
}
