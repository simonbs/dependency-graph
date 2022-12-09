import DirectedGraph
import PackageSwiftFile

public protocol PackageDependencyGraphBuilder {
    func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph
}
