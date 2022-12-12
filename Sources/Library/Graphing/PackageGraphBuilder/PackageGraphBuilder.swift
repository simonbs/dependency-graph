import DirectedGraph
import PackageSwiftFile

public protocol PackageGraphBuilder {
    func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph
}
