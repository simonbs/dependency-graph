import FileSystem
import Foundation

final class FileSystemMock: FileSystem {
    var fileExists = true
    var isDirectory = false
    var directoryContents: [String] = []

    func fileExists(at itemURL: URL) -> Bool {
        return fileExists
    }

    func isDirectory(at itemURL: URL) -> Bool {
        return isDirectory
    }

    func contentsOfDirectory(at directoryURL: URL) -> [String] {
        return directoryContents
    }
}
