import Foundation
import PackageSwiftFile

public protocol PackageSwiftFileParserCache {
    func cache(_ packageSwiftFile: PackageSwiftFile, for url: URL)
    func cachedPackageSwiftFile(for url: URL) -> PackageSwiftFile?
}
