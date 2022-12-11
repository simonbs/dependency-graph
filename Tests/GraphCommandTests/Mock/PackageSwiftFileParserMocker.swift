import Foundation
import PackageSwiftFile
import PackageSwiftFileParser

struct PackageSwiftFileParserMock: PackageSwiftFileParser {
    func parseFile(at fileURL: URL) throws -> PackageSwiftFile {
        return PackageSwiftFile(name: "Example")
    }
}
