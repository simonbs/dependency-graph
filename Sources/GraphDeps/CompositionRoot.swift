import DumpPackageService
import DumpPackageServiceLive
import PackageSwiftFileParser
import PackageSwiftFileParserLive
import ShellCommandRunner
import ShellCommandRunnerLive
import XcodeProjectParser
import XcodeProjectParserLive

public enum CompositionRoot {
    static var xcodeProjectParser: XcodeProjectParser {
        return XcodeProjectParserLive(packageSwiftFileParser: packageSwiftFileParser)
    }
}

private extension CompositionRoot {
    private static var packageSwiftFileParser: PackageSwiftFileParser {
        return PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
    }

    private static var dumpPackageService: DumpPackageService {
        return DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
    }

    private static var shellCommandRunner: ShellCommandRunner {
        return ShellCommandRunnerLive()
    }
}
