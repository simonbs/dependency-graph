import DOTGraphTransformer
import DOTGraphTransformerLive
import DumpPackageService
import DumpPackageServiceLive
import FileSystem
import FileSystemLive
import GraphCommand
import PackageSwiftFileParser
import PackageSwiftFileParserLive
import ProjectRootClassifier
import ProjectRootClassifierLive
import ShellCommandRunner
import ShellCommandRunnerLive
import XcodeDependencyGraphBuilder
import XcodeDependencyGraphBuilderLive
import XcodeProjectParser
import XcodeProjectParserLive

public enum CompositionRoot {
    static var graphCommand: GraphCommand {
        return GraphCommand(projectRootClassifier: projectRootClassifier,
                            xcodeProjectParser: xcodeProjectParser,
                            xcodeDependencyGraphBuilder: xcodeDependencyGraphBuilder,
                            dotGraphTransformer: dotGraphTransformer)
    }
}

private extension CompositionRoot {
    private static var dotGraphTransformer: DOTGraphTransformer {
        return DOTGraphTransformerLive()
    }

    private static var dumpPackageService: DumpPackageService {
        return DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
    }

    private static var fileSystem: FileSystem {
        return FileSystemLive()
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

    private static var xcodeDependencyGraphBuilder: XcodeDependencyGraphBuilder {
        return XcodeDependencyGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser)
    }

    private static var xcodeProjectParser: XcodeProjectParser {
        return XcodeProjectParserLive(fileSystem: fileSystem)
    }
}
