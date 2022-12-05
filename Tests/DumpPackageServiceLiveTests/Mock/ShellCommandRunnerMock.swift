import Foundation
import ShellCommandRunner

final class ShellCommandRunnerMock: ShellCommandRunner {
    private(set) var latestArguments: [String]?
    private(set) var latestDirectoryURL: URL?

    func run(withArguments arguments: [String], fromDirectoryURL directoryURL: URL) -> ShellCommandOutput {
        latestArguments = arguments
        latestDirectoryURL = directoryURL
        return ShellCommandOutput(status: 0, message: "Success")
    }
}
