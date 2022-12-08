import Foundation
import PackageSwiftFile

public protocol PackageSwiftFileParser {
    func parseFile(at fileURL: URL) throws -> PackageSwiftFile
}
