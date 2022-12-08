import FileExistenceChecker
import Foundation

struct FileExistenceCheckerMock: FileExistenceChecker {
    func fileExists(at fileURL: URL) -> Bool {
        return true
    }
}
