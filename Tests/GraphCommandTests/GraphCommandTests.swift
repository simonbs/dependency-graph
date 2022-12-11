@testable import GraphCommand
import XCTest

final class GraphCommandTests: XCTestCase {
    func testInvokesOnlyDotGraphTransformer() throws {
        let dotGraphTransformer = DirectedGraphTransformerMock()
        let mermaidGraphTransformer = DirectedGraphTransformerMock()
        let directedGraphTransformerFactory = DirectedGraphTransformerFactory(dotGraphTransformer: dotGraphTransformer,
                                                                              mermaidGraphTransformer: mermaidGraphTransformer)
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphTransformerFactory: directedGraphTransformerFactory,
                                   stdoutWriter: StdoutWriterMock())
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .dot)
        XCTAssertTrue(dotGraphTransformer.didTransform)
        XCTAssertFalse(mermaidGraphTransformer.didTransform)
    }

    func testInvokesOnlyMermaidGraphTransformer() throws {
        let dotGraphTransformer = DirectedGraphTransformerMock()
        let mermaidGraphTransformer = DirectedGraphTransformerMock()
        let directedGraphTransformerFactory = DirectedGraphTransformerFactory(dotGraphTransformer: dotGraphTransformer,
                                                                              mermaidGraphTransformer: mermaidGraphTransformer)
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphTransformerFactory: directedGraphTransformerFactory,
                                   stdoutWriter: StdoutWriterMock())
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .mermaid)
        XCTAssertTrue(mermaidGraphTransformer.didTransform)
        XCTAssertFalse(dotGraphTransformer.didTransform)
    }

    func testCallsStdoutWriter() throws {
        let dotGraphTransformer = DirectedGraphTransformerMock()
        let mermaidGraphTransformer = DirectedGraphTransformerMock()
        let directedGraphTransformerFactory = DirectedGraphTransformerFactory(dotGraphTransformer: dotGraphTransformer,
                                                                              mermaidGraphTransformer: mermaidGraphTransformer)
        let stdoutWriter = StdoutWriterMock()
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphTransformerFactory: directedGraphTransformerFactory,
                                   stdoutWriter: stdoutWriter)
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .mermaid)
        XCTAssertTrue(stdoutWriter.didWrite)
    }
}
