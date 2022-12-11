@testable import GraphCommand
import XCTest

final class GraphCommandTests: XCTestCase {
    func testInvokesOnlyDotGraphMapper() throws {
        let dotGraphMapper = DirectedGraphMapperMock()
        let mermaidGraphMapper = DirectedGraphMapperMock()
        let directedGraphMapperFactory = DirectedGraphMapperFactory(dotGraphMapper: dotGraphMapper,
                                                                              mermaidGraphMapper: mermaidGraphMapper)
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphMapperFactory: directedGraphMapperFactory,
                                   stdoutWriter: StdoutWriterMock())
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .dot)
        XCTAssertTrue(dotGraphMapper.didTransform)
        XCTAssertFalse(mermaidGraphMapper.didTransform)
    }

    func testInvokesOnlyMermaidGraphMapper() throws {
        let dotGraphMapper = DirectedGraphMapperMock()
        let mermaidGraphMapper = DirectedGraphMapperMock()
        let directedGraphMapperFactory = DirectedGraphMapperFactory(dotGraphMapper: dotGraphMapper,
                                                                              mermaidGraphMapper: mermaidGraphMapper)
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphMapperFactory: directedGraphMapperFactory,
                                   stdoutWriter: StdoutWriterMock())
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .mermaid)
        XCTAssertTrue(mermaidGraphMapper.didTransform)
        XCTAssertFalse(dotGraphMapper.didTransform)
    }

    func testCallsStdoutWriter() throws {
        let dotGraphMapper = DirectedGraphMapperMock()
        let mermaidGraphMapper = DirectedGraphMapperMock()
        let directedGraphMapperFactory = DirectedGraphMapperFactory(dotGraphMapper: dotGraphMapper,
                                                                              mermaidGraphMapper: mermaidGraphMapper)
        let stdoutWriter = StdoutWriterMock()
        let command = GraphCommand(projectRootClassifier: ProjectRootClassifierMock(),
                                   packageSwiftFileParser: PackageSwiftFileParserMock(),
                                   xcodeProjectParser: XcodeProjectParserMock(),
                                   packageDependencyGraphBuilder: PackageDependencyGraphBuilderMock(),
                                   xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilderMock(),
                                   directedGraphMapperFactory: directedGraphMapperFactory,
                                   stdoutWriter: stdoutWriter)
        let fileURL = URL(filePath: "/Users/simon/Developer/Example")
        try command.run(withInput: fileURL.path, syntax: .mermaid)
        XCTAssertTrue(stdoutWriter.didWrite)
    }
}
