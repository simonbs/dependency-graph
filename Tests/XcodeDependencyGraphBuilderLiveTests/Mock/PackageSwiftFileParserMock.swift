import Foundation
import PackageSwiftFile
import PackageSwiftFileParser

private enum PackageSwiftFileParserMockError: LocalizedError {
    case fileURLNotMapped(URL)

    var errorDescription: String? {
        switch self {
        case .fileURLNotMapped(let fileURL):
            return "Package.swift file not mapped for \(fileURL.absoluteString)."
        }
    }
}

struct PackageSwiftFileParserMock: PackageSwiftFileParser {
    func parseFile(at fileURL: URL) throws -> PackageSwiftFile {
        switch fileURL.absoluteString {
        case "file:///Users/simon/Developer/Example/ExamplePackageA/Package.swift":
            return .mockA
        case "file:///Users/simon/Developer/Example/ExamplePackageB/Package.swift":
            return .mockB
        default:
            throw PackageSwiftFileParserMockError.fileURLNotMapped(fileURL)
        }
    }
}

private extension PackageSwiftFile {
    static var mockA: PackageSwiftFile {
        return PackageSwiftFile(name: "ExamplePackageA", products: [
            PackageSwiftFile.Product(name: "ExampleLibraryA", targets: ["ExampleLibraryA"])
        ], targets: [
            PackageSwiftFile.Target(name: "ExampleLibraryA")
        ], dependencies: [])
    }

    static var mockB: PackageSwiftFile {
        return PackageSwiftFile(name: "ExamplePackageB", products: [
            PackageSwiftFile.Product(name: "ExampleLibraryB", targets: ["ExampleLibraryB"])
        ], targets: [
            PackageSwiftFile.Target(name: "ExampleLibraryB")
        ], dependencies: [])
    }
}
