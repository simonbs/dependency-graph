import DirectedGraph
import DirectedGraphMapper

final class DirectedGraphMapperMock: DirectedGraphMapper {
    private(set) var didMap = false

    private let result: String

    init(result: String = "Hello world!") {
        self.result = result
    }

    func map(_ graph: DirectedGraph) throws -> String {
        didMap = true
        return result
    }
}
