import Foundation

public protocol ShellCommandRunner {
    func run(withArguments arguments: [String], fromDirectoryURL directoryURL: URL) -> ShellCommandOutput
}
