import Foundation

public protocol DumpPackageService {
    func dumpPackageForSwiftPackageFile(at fileURL: URL) throws -> Data
}
