import DirectedGraphMapper
import DirectedGraphWriter
import DOTGraphMapper
import DumpPackageService
import DumpPackageServiceLive
import FileSystem
import FileSystemLive
import GraphCommand
import MappingDirectedGraphWriter
import MermaidGraphMapper
import PackageDependencyGraphBuilder
import PackageDependencyGraphBuilderLive
import PackageSwiftFileParser
import PackageSwiftFileParserLive
import ProjectRootClassifier
import ProjectRootClassifierLive
import ShellCommandRunner
import ShellCommandRunnerLive
import StdoutWriter
import XcodeProjectDependencyGraphBuilder
import XcodeProjectDependencyGraphBuilderLive
import XcodeProjectParser
import XcodeProjectParserLive

public enum CompositionRoot {
    static var graphCommand: GraphCommand {
        return GraphCommand(projectRootClassifier: projectRootClassifier,
                            packageSwiftFileParser: packageSwiftFileParser,
                            xcodeProjectParser: xcodeProjectParser,
                            packageDependencyGraphBuilder: packageDependencyGraphBuilder,
                            xcodeProjectDependencyGraphBuilder: xcodeProjectDependencyGraphBuilder,
                            directedGraphWriterFactory: directedGraphWriterFactory)
    }
}

private extension CompositionRoot {
    private static var directedGraphWriterFactory: DirectedGraphWriterFactory {
        return DirectedGraphWriterFactory(dotGraphWriter: dotGraphWriter, mermaidGraphWriter: mermaidGraphWriter)
    }

    private static var dotGraphWriter: some DirectedGraphWriter {
        return MappingDirectedGraphWriter(mapper: DOTGraphMapper(), writer: stdoutWriter)
    }

    private static var dumpPackageService: DumpPackageService {
        return DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
    }

    private static var fileSystem: FileSystem {
        return FileSystemLive()
    }

    private static var mermaidGraphWriter: some DirectedGraphWriter {
        return MappingDirectedGraphWriter(mapper: MermaidGraphMapper(), writer: stdoutWriter)
    }

    private static var packageDependencyGraphBuilder: PackageDependencyGraphBuilder {
        return PackageDependencyGraphBuilderLive()
    }

    private static var packageSwiftFileParser: PackageSwiftFileParser {
        return PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
    }

    private static var projectRootClassifier: ProjectRootClassifier {
        return ProjectRootClassifierLive(fileSystem: fileSystem)
    }

    private static var shellCommandRunner: ShellCommandRunner {
        return ShellCommandRunnerLive()
    }

    private static var stdoutWriter: StdoutWriter {
        return StdoutWriter()
    }

    private static var xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilder {
        return XcodeProjectDependencyGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser,
                                                      packageDependencyGraphBuilder: packageDependencyGraphBuilder)
    }

    private static var xcodeProjectParser: XcodeProjectParser {
        return XcodeProjectParserLive(fileSystem: fileSystem)
    }
}
