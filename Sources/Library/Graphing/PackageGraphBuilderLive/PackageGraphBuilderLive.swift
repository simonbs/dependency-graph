import DirectedGraph
import DirectedGraphXcodeHelpers
import Foundation
import PackageGraphBuilder
import PackageSwiftFile

public enum PackageGraphBuilderLiveError: LocalizedError {
    case dependencyNotFound(dependency: String, dependant: String)

    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(dependency, dependant):
            return "\(dependant) depends on \(dependency) but the dependency was not found in the graph."
        }
    }
}

public struct PackageGraphBuilderLive: PackageGraphBuilder {
    private let packagesOnly: Bool

    public init(packagesOnly: Bool) {
        self.packagesOnly = packagesOnly
    }

    public func buildGraph(from packageSwiftFile: PackageSwiftFile) throws -> DirectedGraph {
        if packagesOnly {
            return try PackagesOnlyGraphBuilder.buildGraph(from: packageSwiftFile)
        } else {
            return try AllDependenciesGraphBuilder.buildGraph(from: packageSwiftFile)
        }
    }
}
