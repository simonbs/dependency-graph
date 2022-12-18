@testable import GraphCommand
import XCTest

final class GraphCommandTests: XCTestCase {
    func testInvokesOnlyD2GraphWriter() throws {
        let d2GraphWriter = DirectedGraphWriterMock()
        let dotGraphWriter = DirectedGraphWriterMock()
        let mermaidGraphWriter = DirectedGraphWriterMock()
        let directedGraphWriterFactory = DirectedGraphWriterFactory(
            d2GraphWriter: d2GraphWriter,
            dotGraphWriter: dotGraphWriter,
            mermaidGraphWriter: mermaidGraphWriter
        )
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageGraphBuilder: PackageGraphBuilderMock(),
                                   xcodeProjectGraphBuilder: XcodeProjectGraphBuilderMock(),
                                   directedGraphWriterFactory: directedGraphWriterFactory)
        let fileURL = NSURL.fileURL(withPath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .d2)
        XCTAssertTrue(d2GraphWriter.didWrite)
        XCTAssertFalse(dotGraphWriter.didWrite)
        XCTAssertFalse(mermaidGraphWriter.didWrite)
    }

    func testInvokesOnlyDotGraphWriter() throws {
        let d2GraphWriter = DirectedGraphWriterMock()
        let dotGraphWriter = DirectedGraphWriterMock()
        let mermaidGraphWriter = DirectedGraphWriterMock()
        let directedGraphWriterFactory = DirectedGraphWriterFactory(
            d2GraphWriter: d2GraphWriter,
            dotGraphWriter: dotGraphWriter,
            mermaidGraphWriter: mermaidGraphWriter
        )
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageGraphBuilder: PackageGraphBuilderMock(),
                                   xcodeProjectGraphBuilder: XcodeProjectGraphBuilderMock(),
                                   directedGraphWriterFactory: directedGraphWriterFactory)
        let fileURL = NSURL.fileURL(withPath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .dot)
        XCTAssertFalse(d2GraphWriter.didWrite)
        XCTAssertTrue(dotGraphWriter.didWrite)
        XCTAssertFalse(mermaidGraphWriter.didWrite)
    }

    func testInvokesOnlyMermaidGraphWriter() throws {
        let d2GraphWriter = DirectedGraphWriterMock()
        let dotGraphWriter = DirectedGraphWriterMock()
        let mermaidGraphWriter = DirectedGraphWriterMock()
        let directedGraphWriterFactory = DirectedGraphWriterFactory(
            d2GraphWriter: d2GraphWriter,
            dotGraphWriter: dotGraphWriter,
            mermaidGraphWriter: mermaidGraphWriter
        )
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageGraphBuilder: PackageGraphBuilderMock(),
                                   xcodeProjectGraphBuilder: XcodeProjectGraphBuilderMock(),
                                   directedGraphWriterFactory: directedGraphWriterFactory)
        let fileURL = NSURL.fileURL(withPath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .mermaid)
        XCTAssertFalse(d2GraphWriter.didWrite)
        XCTAssertFalse(dotGraphWriter.didWrite)
        XCTAssertTrue(mermaidGraphWriter.didWrite)
    }
}
