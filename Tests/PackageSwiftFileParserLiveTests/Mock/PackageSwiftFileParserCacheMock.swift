import Foundation
import PackageSwiftFile
import PackageSwiftFileParserCache

final class PackageSwiftFileParserCacheMock: PackageSwiftFileParserCache {
    private var values: [URL: PackageSwiftFile] = [:]

    func cache(_ packageSwiftFile: PackageSwiftFile, for url: URL) {
        values[url] = packageSwiftFile
    }

    func cachedPackageSwiftFile(for url: URL) -> PackageSwiftFile? {
        return values[url]
    }
}
