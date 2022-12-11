import Foundation
import PackageSwiftFile
import PackageSwiftFileParserCache

public final class PackageSwiftFileParserCacheLive: PackageSwiftFileParserCache {
    private var values: [URL: PackageSwiftFile] = [:]

    public init() {}

    public func cache(_ packageSwiftFile: PackageSwiftFile, for url: URL) {
        values[url] = packageSwiftFile
    }

    public func cachedPackageSwiftFile(for url: URL) -> PackageSwiftFile? {
        return values[url]
    }
}
