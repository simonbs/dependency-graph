import DumpPackageService
import Foundation
import PackageSwiftFile
import PackageSwiftFileParser

private enum PackageSwiftFileParserLiveError: LocalizedError {
    case failedParsing(URL, Error)

    var errorDescription: String? {
        switch self {
        case .failedParsing(let fileURL, let decodingError):
            return "Failed parsing dumped Package.swift file at \(fileURL.path): \(decodingError)"
        }
    }
}

public struct PackageSwiftFileParserLive: PackageSwiftFileParser {
    private let dumpPackageService: DumpPackageService

    public init(dumpPackageService: DumpPackageService) {
        self.dumpPackageService = dumpPackageService
    }

    public func parseFile(at fileURL: URL) throws -> PackageSwiftFile {
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
