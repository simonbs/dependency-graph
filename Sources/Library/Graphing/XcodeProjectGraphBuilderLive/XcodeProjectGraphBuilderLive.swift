import DirectedGraph
import DirectedGraphXcodeHelpers
import Foundation
import PackageGraphBuilder
import PackageSwiftFile
import PackageSwiftFileParser
import XcodeProject
import XcodeProjectGraphBuilder

public enum XcodeProjectGraphBuilderLiveError: LocalizedError {
    case dependencyNotFound(dependency: String, dependant: String)

    public var errorDescription: String? {
        switch self {
        case let .dependencyNotFound(dependency, dependant):
            return "\(dependant) depends on \(dependency) but the dependency was not found in the graph."
        }
    }
}

public final class XcodeProjectGraphBuilderLive: XcodeProjectGraphBuilder {
    private let packageSwiftFileParser: PackageSwiftFileParser
    private let packageGraphBuilder: PackageGraphBuilder
    private let packagesOnly: Bool

    public init(packageSwiftFileParser: PackageSwiftFileParser, packageGraphBuilder: PackageGraphBuilder, packagesOnly: Bool) {
        self.packageSwiftFileParser = packageSwiftFileParser
        self.packageGraphBuilder = packageGraphBuilder
        self.packagesOnly = packagesOnly
    }

    public func buildGraph(from xcodeProject: XcodeProject) throws -> DirectedGraph {
        if packagesOnly {
            let graphBuilder = PackagesOnlyGraphBuilder(packageSwiftFileParser: packageSwiftFileParser, packageGraphBuilder: packageGraphBuilder)
            return try graphBuilder.buildGraph(from: xcodeProject)
        } else {
            let graphBuilder = AllDependenciesGraphBuilder(packageSwiftFileParser: packageSwiftFileParser, packageGraphBuilder: packageGraphBuilder)
            return try graphBuilder.buildGraph(from: xcodeProject)
        }
    }
}
