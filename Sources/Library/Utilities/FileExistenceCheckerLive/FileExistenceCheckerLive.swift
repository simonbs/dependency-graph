import FileExistenceChecker
import Foundation

public struct FileExistenceCheckerLive: FileExistenceChecker {
    public init() {}

    public func fileExists(at fileURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.absoluteString)
    }
}
