import DOTGraphTransformer
import Foundation
import ProjectRootClassifier
import XcodeDependencyGraphBuilder
import XcodeProjectParser

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
        let xcodeProject = try xcodeProjectParser.parseProject(at: fileURL)
        let graph = try xcodeDependencyGraphBuilder.buildGraph(from: xcodeProject)
        let dotGraph = try dotGraphTransformer.transform(graph)
        print(dotGraph)
    }
}
