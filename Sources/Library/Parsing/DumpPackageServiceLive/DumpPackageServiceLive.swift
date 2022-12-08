import DumpPackageService
import Foundation
import ShellCommandRunner

public enum DumpPackageServiceLiveError: LocalizedError {
    case invalidPackageSwiftFileURL
    case unexpectedTerminationStatus(Int32)
    case failedConvertingStringToData

    public var errorDescription: String? {
        switch self {
        case .invalidPackageSwiftFileURL:
            return "Expected URL to a Package.swift file."
        case .unexpectedTerminationStatus(let status):
            return "Unexpected termination status \(status)."
        case .failedConvertingStringToData:
            return "Failed converting string to data."
        }
    }
}

public struct DumpPackageServiceLive: DumpPackageService {
    private let shellCommandRunner: ShellCommandRunner

    public init(shellCommandRunner: ShellCommandRunner) {
        self.shellCommandRunner = shellCommandRunner
    }

    public func dumpPackageForSwiftPackageFile(at fileURL: URL) throws -> Data {
        guard fileURL.lastPathComponent == "Package.swift" else {
            throw DumpPackageServiceLiveError.invalidPackageSwiftFileURL
        }
        let directoryURL = fileURL.deletingLastPathComponent()
        return try dumpPackage(at: directoryURL)
    }
}

private extension DumpPackageServiceLive {
    private func dumpPackage(at directoryURL: URL) throws -> Data {
        let output = shellCommandRunner.run(withArguments: ["swift", "package", "dump-package"], fromDirectoryURL: directoryURL)
        guard output.status == 0 else {
            throw DumpPackageServiceLiveError.unexpectedTerminationStatus(output.status)
        }
        guard let data = output.message.data(using: .utf8) else {
            throw DumpPackageServiceLiveError.failedConvertingStringToData
        }
        return data
    }
}
