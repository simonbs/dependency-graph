import FileSystem
import Foundation

public struct FileSystemLive: FileSystem {
    public init() {}

    public func fileExists(at itemURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: itemURL.path)
    }

    public func isDirectory(at itemURL: URL) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: itemURL.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }

    public func contentsOfDirectory(at directoryURL: URL) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
        } catch {
            return []
        }
    }
}
