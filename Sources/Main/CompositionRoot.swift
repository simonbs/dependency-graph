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
import PackageGraphBuilder
import PackageGraphBuilderLive
import PackageSwiftFileParser
import PackageSwiftFileParserCache
import PackageSwiftFileParserCacheLive
import PackageSwiftFileParserLive
import ProjectRootClassifier
import ProjectRootClassifierLive
import ShellCommandRunner
import ShellCommandRunnerLive
import StdoutWriter
import XcodeProjectGraphBuilder
import XcodeProjectGraphBuilderLive
import XcodeProjectParser
import XcodeProjectParserLive

public enum CompositionRoot {
    static func graphCommand(packagesOnly: Bool, nodeSpacing: Float?, rankSpacing: Float?) -> GraphCommand {
        let directedGraphWriterFactory = directedGraphWriterFactory(nodeSpacing: nodeSpacing, rankSpacing: rankSpacing)
        return GraphCommand(projectRootClassifier: projectRootClassifier,
                            packageSwiftFileParser: packageSwiftFileParser,
                            xcodeProjectParser: xcodeProjectParser,
                            packageGraphBuilder: packageGraphBuilder(packagesOnly: packagesOnly),
                            xcodeProjectGraphBuilder: xcodeProjectGraphBuilder(packagesOnly: packagesOnly),
                            directedGraphWriterFactory: directedGraphWriterFactory)
    }
}

private extension CompositionRoot {
    private static func directedGraphWriterFactory(nodeSpacing: Float?, rankSpacing: Float?) -> DirectedGraphWriterFactory {
        let dotGraphWriter = dotGraphWriter(nodesep: nodeSpacing, ranksep: rankSpacing)
        let mermaidGraphWriter = mermaidGraphWriter(nodeSpacing: nodeSpacing.map(Int.init), rankSpacing: rankSpacing.map(Int.init))
        return DirectedGraphWriterFactory(dotGraphWriter: dotGraphWriter, mermaidGraphWriter: mermaidGraphWriter)
    }

    private static func dotGraphWriter(nodesep: Float?, ranksep: Float?) -> some DirectedGraphWriter {
        let settings = DOTGraphSettings(nodesep: nodesep, ranksep: ranksep)
        let mapper = DOTGraphMapper(settings: settings)
        return MappingDirectedGraphWriter(mapper: mapper, writer: stdoutWriter)
    }

    private static var dumpPackageService: DumpPackageService {
        return DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
    }

    private static var fileSystem: FileSystem {
        return FileSystemLive()
    }

    private static func mermaidGraphWriter(nodeSpacing: Int?, rankSpacing: Int?) -> some DirectedGraphWriter {
        let settings = MermaidGraphSettings(nodeSpacing: nodeSpacing, rankSpacing: rankSpacing)
        let mapper = MermaidGraphMapper(settings: settings)
        return MappingDirectedGraphWriter(mapper: mapper, writer: stdoutWriter)
    }

    private static func packageGraphBuilder(packagesOnly: Bool) -> PackageGraphBuilder {
        return PackageGraphBuilderLive(packagesOnly: packagesOnly)
    }

    private static var packageSwiftFileParser: PackageSwiftFileParser {
        return PackageSwiftFileParserLive(cache: packageSwiftFileParserCache, dumpPackageService: dumpPackageService)
    }

    private static let packageSwiftFileParserCache: PackageSwiftFileParserCache = PackageSwiftFileParserCacheLive()

    private static var projectRootClassifier: ProjectRootClassifier {
        return ProjectRootClassifierLive(fileSystem: fileSystem)
    }

    private static var shellCommandRunner: ShellCommandRunner {
        return ShellCommandRunnerLive()
    }

    private static var stdoutWriter: StdoutWriter {
        return StdoutWriter()
    }

    private static func xcodeProjectGraphBuilder(packagesOnly: Bool) -> XcodeProjectGraphBuilder {
        return XcodeProjectGraphBuilderLive(packageSwiftFileParser: packageSwiftFileParser,
                                            packageGraphBuilder: packageGraphBuilder(packagesOnly: packagesOnly),
                                            packagesOnly: packagesOnly)
    }

    private static var xcodeProjectParser: XcodeProjectParser {
        return XcodeProjectParserLive(fileSystem: fileSystem)
    }
}
