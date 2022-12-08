import DOTGraphTransformer
import Foundation
import ProjectRootClassifier
import XcodeDependencyGraphBuilder
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
    private let xcodeProjectParser: XcodeProjectParser
    private let xcodeDependencyGraphBuilder: XcodeDependencyGraphBuilder
    private let dotGraphTransformer: DOTGraphTransformer

    public init(projectRootClassifier: ProjectRootClassifier,
                xcodeProjectParser: XcodeProjectParser,
                xcodeDependencyGraphBuilder: XcodeDependencyGraphBuilder,
                dotGraphTransformer: DOTGraphTransformer) {
        self.projectRootClassifier = projectRootClassifier
        self.xcodeProjectParser = xcodeProjectParser
        self.xcodeDependencyGraphBuilder = xcodeDependencyGraphBuilder
        self.dotGraphTransformer = dotGraphTransformer
    }

    public func run(withInput input: String) throws {
        let fileURL = URL(filePath: input)
        let projectRoot = projectRootClassifier.classifyProject(at: fileURL)
        switch projectRoot {
        case .xcodeproj(let xcodeprojFileURL):
            let xcodeProject = try xcodeProjectParser.parseProject(at: xcodeprojFileURL)
            let graph = try xcodeDependencyGraphBuilder.buildGraph(from: xcodeProject)
            let dotGraph = try dotGraphTransformer.transform(graph)
            print(dotGraph)
        case .packageSwiftFile(let packageSwiftFileURL):
            throw GraphCommandError.unknownProject(packageSwiftFileURL)
        case .unknown:
            throw GraphCommandError.unknownProject(fileURL)
        }
    }
}
