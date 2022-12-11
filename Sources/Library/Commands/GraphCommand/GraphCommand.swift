import DirectedGraphTransformer
import Foundation
import PackageDependencyGraphBuilder
import PackageSwiftFileParser
import ProjectRootClassifier
import StdoutWriter
import XcodeProjectDependencyGraphBuilder
import XcodeProjectParser

private enum GraphCommandError: LocalizedError {
    case unknownProject(URL)

    var errorDescription: String? {
        switch self {
        case .unknownProject(let fileURL):
            return "Unknown project at \(fileURL.path)"
        }
    }
}

public struct GraphCommand {
    private let projectRootClassifier: ProjectRootClassifier
    private let packageSwiftFileParser: PackageSwiftFileParser
    private let xcodeProjectParser: XcodeProjectParser
    private let packageDependencyGraphBuilder: PackageDependencyGraphBuilder
    private let xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilder
    private let directedGraphTransformerFactory: DirectedGraphTransformerFactory
    private let stdoutWriter: StdoutWriter

    public init(projectRootClassifier: ProjectRootClassifier,
                packageSwiftFileParser: PackageSwiftFileParser,
                xcodeProjectParser: XcodeProjectParser,
                packageDependencyGraphBuilder: PackageDependencyGraphBuilder,
                xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilder,
                directedGraphTransformerFactory: DirectedGraphTransformerFactory,
                stdoutWriter: StdoutWriter) {
        self.projectRootClassifier = projectRootClassifier
        self.xcodeProjectParser = xcodeProjectParser
        self.packageSwiftFileParser = packageSwiftFileParser
        self.packageDependencyGraphBuilder = packageDependencyGraphBuilder
        self.xcodeProjectDependencyGraphBuilder = xcodeProjectDependencyGraphBuilder
        self.directedGraphTransformerFactory = directedGraphTransformerFactory
        self.stdoutWriter = stdoutWriter
    }

    public func run(withInput input: String, syntax: Syntax) throws {
        let fileURL = URL(filePath: input)
        let projectRoot = projectRootClassifier.classifyProject(at: fileURL)
        let directedGraphTransformer = directedGraphTransformerFactory.transformer(for: syntax)
        switch projectRoot {
        case .xcodeproj(let xcodeprojFileURL):
            let xcodeProject = try xcodeProjectParser.parseProject(at: xcodeprojFileURL)
            let graph = try xcodeProjectDependencyGraphBuilder.buildGraph(from: xcodeProject)
            let transformedGraph = try directedGraphTransformer.transform(graph)
            stdoutWriter.write(transformedGraph)
        case .packageSwiftFile(let packageSwiftFileURL):
            let packageSwiftFile = try packageSwiftFileParser.parseFile(at: packageSwiftFileURL)
            let graph = try packageDependencyGraphBuilder.buildGraph(from: packageSwiftFile)
            let transformedGraph = try directedGraphTransformer.transform(graph)
            stdoutWriter.write(transformedGraph)
        case .unknown:
            throw GraphCommandError.unknownProject(fileURL)
        }
    }
}
