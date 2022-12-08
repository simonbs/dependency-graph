import DOTGraphTransformer
import DOTGraphTransformerLive
import DumpPackageService
import DumpPackageServiceLive
import FileExistenceChecker
import FileExistenceCheckerLive
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

    private static var fileExistenceChecker: FileExistenceChecker {
        return FileExistenceCheckerLive()
    }

    private static var packageSwiftFileParser: PackageSwiftFileParser {
        return PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
    }

    private static var projectRootClassifier: ProjectRootClassifier {
        return ProjectRootClassifierLive(fileExistenceChecker: fileExistenceChecker)
    }

    private static var shellCommandRunner: ShellCommandRunner {
        return ShellCommandRunnerLive()
    }

    private static var xcodeDependencyGraphBuilder: XcodeDependencyGraphBuilder {
        return XcodeDependencyGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser)
    }

    private static var xcodeProjectParser: XcodeProjectParser {
        return XcodeProjectParserLive(fileExistenceChecker: fileExistenceChecker)
    }
}
