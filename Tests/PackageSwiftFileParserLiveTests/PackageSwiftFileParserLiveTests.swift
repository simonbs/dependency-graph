import PackageSwiftFile
import PackageSwiftFileParser
@testable import PackageSwiftFileParserLive
import XCTest

final class PackageSwiftFileParserLiveTests: XCTestCase {
    func testParsesName() throws {
        let cache = PackageSwiftFileParserCacheMock()
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(cache: cache, dumpPackageService: dumpPackageService)
        let packageSwiftFile = try parser.parseFile(at: URL.Mock.examplePackageA)
        XCTAssertEqual(packageSwiftFile.name, "ExamplePackageA")
    }

    func testParsesProducts() throws {
        let cache = PackageSwiftFileParserCacheMock()
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(cache: cache, dumpPackageService: dumpPackageService)
        let packageSwiftFile = try parser.parseFile(at: URL.Mock.examplePackageA)
        XCTAssertEqual(packageSwiftFile.products, [
            PackageSwiftFile.Product(name: "ExampleLibraryA", targets: ["ExampleLibraryA"])
        ])
    }

    func testParsesTargets() throws {
        let cache = PackageSwiftFileParserCacheMock()
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(cache: cache, dumpPackageService: dumpPackageService)
        let packageSwiftFile = try parser.parseFile(at: URL.Mock.examplePackageA)
        XCTAssertEqual(packageSwiftFile.targets, [
            PackageSwiftFile.Target(name: "ExampleLibraryA")
        ])
    }

    func testParsesDependencies() throws {
        let cache = PackageSwiftFileParserCacheMock()
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(cache: cache, dumpPackageService: dumpPackageService)
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

    func testReadsPackageSwiftFileFromCache() throws {
        let cachedPackageSwiftFile = PackageSwiftFile(name: "foo")
        let fileURL = NSURL.fileURL(withPath: "/Users/simonbs/Developer/foo")
        let cache = PackageSwiftFileParserCacheMock()
        cache.cache(cachedPackageSwiftFile, for: fileURL)
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(cache: cache, dumpPackageService: dumpPackageService)
        let parsedPackageSwiftFile = try parser.parseFile(at: fileURL)
        XCTAssertEqual(parsedPackageSwiftFile, cachedPackageSwiftFile)
    }

    func testParsesByNameDependencyWithPlatformNames() throws {
        let cache = PackageSwiftFileParserCacheMock()
        let dumpPackageService = DumpPackageServiceMock()
        let parser = PackageSwiftFileParserLive(cache: cache, dumpPackageService: dumpPackageService)
        let packageSwiftFile = try parser.parseFile(at: URL.Mock.examplePackageD)
        let expectedPackageSwiftFile = PackageSwiftFile(
            name: "ExamplePackageD",
            products: [
                PackageSwiftFile.Product(name: "ExampleLibraryD", targets: ["ExampleLibraryD"])
            ],
            targets: [
                PackageSwiftFile.Target(name: "ExampleLibraryD", dependencies: [
                    .name("ExampleLibraryC")
                ])
            ],
            dependencies: [
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
                )
            ])
        XCTAssertEqual(packageSwiftFile, expectedPackageSwiftFile)
    }
}
