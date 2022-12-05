import Foundation

public protocol PackageSwiftFileParser {
    func parseFile(at fileURL: URL) throws -> PackageSwiftFile
}
