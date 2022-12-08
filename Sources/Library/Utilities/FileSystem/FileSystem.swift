import Foundation

public protocol FileSystem {
    func fileExists(at itemURL: URL) -> Bool
    func isDirectory(at itemURL: URL) -> Bool
    func contentsOfDirectory(at directoryURL: URL) -> [String]
}
