import DumpPackageService
import Foundation
import PackageSwiftFile
import PackageSwiftFileParser
import PackageSwiftFileParserCache

private enum PackageSwiftFileParserLiveError: LocalizedError {
    case failedParsing(URL, Error)

    var errorDescription: String? {
        switch self {
        case let .failedParsing(fileURL, decodingError):
            return "Failed parsing dumped Package.swift file at \(fileURL.path): \(decodingError)"
        }
    }
}

public final class PackageSwiftFileParserLive: PackageSwiftFileParser {
    private let cache: PackageSwiftFileParserCache
    private let dumpPackageService: DumpPackageService

    public init(cache: PackageSwiftFileParserCache, dumpPackageService: DumpPackageService) {
        self.cache = cache
        self.dumpPackageService = dumpPackageService
    }

    public func parseFile(at fileURL: URL) throws -> PackageSwiftFile {
        if let packageSwiftFile = cache.cachedPackageSwiftFile(for: fileURL) {
            return packageSwiftFile
        } else {
            let packageSwiftFile = try justParseFile(at: fileURL)
            cache.cache(packageSwiftFile, for: fileURL)
            return packageSwiftFile
        }
    }
}

private extension PackageSwiftFileParserLive {
    private func justParseFile(at fileURL: URL) throws -> PackageSwiftFile {
        do {
            let contents = try dumpPackageService.dumpPackageForSwiftPackageFile(at: fileURL)
            let decoder = JSONDecoder()
            let intermediate = try decoder.decode(IntermediatePackageSwiftFile.self, from: contents)
            let mapper = PackageSwiftFileMapper(packageSwiftFileParser: self)
            return try mapper.map(intermediate)
        } catch {
            throw PackageSwiftFileParserLiveError.failedParsing(fileURL, error)
        }
    }
}
