import DirectedGraphTransformer
import DOTGraphTransformer
import DumpPackageService
import DumpPackageServiceLive
import FileSystem
import FileSystemLive
import GraphCommand
import MermaidGraphTransformer
import PackageDependencyGraphBuilder
import PackageDependencyGraphBuilderLive
import PackageSwiftFileParser
import PackageSwiftFileParserLive
import ProjectRootClassifier
import ProjectRootClassifierLive
import ShellCommandRunner
import ShellCommandRunnerLive
import StdoutWriter
import StdoutWriterLive
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
                            directedGraphTransformerFactory: directedGraphTransformerFactory,
                            stdoutWriter: stdoutWriter)
    }
}

private extension CompositionRoot {
    private static var directedGraphTransformerFactory: DirectedGraphTransformerFactory {
        return DirectedGraphTransformerFactory(dotGraphTransformer: DOTGraphTransformer(),
                                               mermaidGraphTransformer: MermaidGraphTransformer())
    }

    private static var dumpPackageService: DumpPackageService {
        return DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
    }

    private static var fileSystem: FileSystem {
        return FileSystemLive()
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
        return StdoutWriterLive()
    }

    private static var xcodeProjectDependencyGraphBuilder: XcodeProjectDependencyGraphBuilder {
        return XcodeProjectDependencyGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser,
                                                      packageDependencyGraphBuilder: packageDependencyGraphBuilder)
    }

    private static var xcodeProjectParser: XcodeProjectParser {
        return XcodeProjectParserLive(fileSystem: fileSystem)
    }
}
