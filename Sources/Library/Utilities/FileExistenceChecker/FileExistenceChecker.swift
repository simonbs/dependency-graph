import Foundation

public protocol FileExistenceChecker {
    func fileExists(at fileURL: URL) -> Bool
}
