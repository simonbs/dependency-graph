@testable import DumpPackageServiceLive
import XCTest

final class DumpPackageServiceLiveTests: XCTestCase {
    func testThrowsWhenReceivingInvalidPackageSwiftFileURL() throws {
        let shellCommandRunner = ShellCommandRunnerMock()
        let service = DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
        let fileURL = URL(fileURLWithPath: "/Users/john/Mock/NotAPackageSwiftFile")
        XCTAssertThrowsError(try service.dumpPackageForSwiftPackageFile(at: fileURL))
    }

    func testInvokesDumpPackageCommandOnSwiftCLI() throws {
        let shellCommandRunner = ShellCommandRunnerMock()
        let service = DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
        let fileURL = URL(fileURLWithPath: "/Users/john/Mock/Package.swift")
        _ = try service.dumpPackageForSwiftPackageFile(at: fileURL)
        XCTAssertEqual(shellCommandRunner.latestArguments, ["swift", "package", "dump-package"])
    }

    func testSetsCurrentDirectoryToSwiftPackage() throws {
        let shellCommandRunner = ShellCommandRunnerMock()
        let service = DumpPackageServiceLive(shellCommandRunner: shellCommandRunner)
        let fileURL = URL(fileURLWithPath: "/Users/john/Mock/Package.swift")
        _ = try service.dumpPackageForSwiftPackageFile(at: fileURL)
        XCTAssertEqual(shellCommandRunner.latestDirectoryURL, NSURL.fileURL(withPath: "/Users/john/Mock/"))
    }
}
