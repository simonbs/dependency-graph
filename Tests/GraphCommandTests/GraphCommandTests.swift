@testable import GraphCommand
import XCTest

final class GraphCommandTests: XCTestCase {
    func testInvokesOnlyDotGraphWriter() throws {
        let dotGraphWriter = DirectedGraphWriterMock()
        let mermaidGraphWriter = DirectedGraphWriterMock()
        let directedGraphWriterFactory = DirectedGraphWriterFactory(dotGraphWriter: dotGraphWriter, mermaidGraphWriter: mermaidGraphWriter)
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphWriterFactory: directedGraphWriterFactory)
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .dot)
        XCTAssertTrue(dotGraphWriter.didWrite)
        XCTAssertFalse(mermaidGraphWriter.didWrite)
    }

    func testInvokesOnlyMermaidGraphWriter() throws {
        let dotGraphWriter = DirectedGraphWriterMock()
        let mermaidGraphWriter = DirectedGraphWriterMock()
        let directedGraphWriterFactory = DirectedGraphWriterFactory(dotGraphWriter: dotGraphWriter, mermaidGraphWriter: mermaidGraphWriter)
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphWriterFactory: directedGraphWriterFactory)
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .mermaid)
        XCTAssertTrue(mermaidGraphWriter.didWrite)
        XCTAssertFalse(dotGraphWriter.didWrite)
    }
}
