import Foundation
import ShellCommandRunner

public struct ShellCommandRunnerLive: ShellCommandRunner {
    public init() {}

    public func run(withArguments arguments: [String], fromDirectoryURL directoryURL: URL) -> ShellCommandOutput {
        let task = Process()
        let pipe = Pipe()
        task.currentDirectoryURL = directoryURL
        task.standardOutput = pipe
        task.arguments = ["-c", arguments.joined(separator: " ")]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        let message = String(data: data, encoding: .utf8)!
        let status = task.terminationStatus
        return ShellCommandOutput(status: status, message: message)
    }
}
