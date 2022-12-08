import FileSystem
import Foundation

struct FileSystemMock: FileSystem {
    func fileExists(at itemURL: URL) -> Bool {
        return true
    }

    func isDirectory(at itemURL: URL) -> Bool {
        return false
    }

    func contentsOfDirectory(at directoryURL: URL) -> [String] {
        return []
    }
}
