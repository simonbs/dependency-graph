import DumpPackageService
import Foundation
import PackageSwiftFileParser

public struct PackageSwiftFileParserLive: PackageSwiftFileParser {
    private let dumpPackageService: DumpPackageService

    public init(dumpPackageService: DumpPackageService) {
        self.dumpPackageService = dumpPackageService
    }

    public func parseFile(at fileURL: URL) throws -> PackageSwiftFile {
        let contents = try dumpPackageService.dumpPackageForSwiftPackageFile(at: fileURL)
        let decoder = JSONDecoder()
        let intermediate = try decoder.decode(IntermediatePackageSwiftFile.self, from: contents)
        let mapper = PackageSwiftFileMapper(dumpPackageService: dumpPackageService, packageSwiftFileParser: self)
        return try mapper.map(intermediate)
    }
}
