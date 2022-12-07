import PackageSwiftFile
import PackageSwiftFileParser
@testable import PackageSwiftFileParserLive
import XCTest

final class PackageSwiftFileParserLiveTests: XCTestCase {
    func testParsesName() throws {
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.examplePackageA)
        XCTAssertEqual(swiftPackageFile.name, "ExamplePackageA")
    }

    func testParsesProducts() throws {
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.examplePackageA)
        XCTAssertEqual(swiftPackageFile.products, [
            PackageSwiftFile.Product(name: "ExampleLibraryA", targets: ["ExampleLibraryA"])
        ])
    }

    func testParsesTargets() throws {
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.examplePackageA)
        XCTAssertEqual(swiftPackageFile.targets, [
            PackageSwiftFile.Target(name: "ExampleLibraryA")
        ])
    }

    func testParsesDependencies() throws {
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.examplePackageB)
        XCTAssertEqual(swiftPackageFile.dependencies, [
            .fileSystem(
                identity: "examplepackagec",
                path: "/Users/simon/Developer/Example/ExamplePackageC",
                packageSwiftFile: PackageSwiftFile(
                    name: "ExamplePackageC",
                    products: [
                        .init(name: "ExampleLibraryC", targets: ["ExampleLibraryC"])
                    ],
                    targets: [
                        .init(name: "ExampleLibraryC")
                    ]
                )
            ),
            .sourceControl(identity: "keyboardtoolbar")
        ])
    }
}
