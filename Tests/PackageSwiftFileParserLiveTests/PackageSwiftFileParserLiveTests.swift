import PackageSwiftFile
import PackageSwiftFileParser
@testable import PackageSwiftFileParserLive
import XCTest

final class PackageSwiftFileParserLiveTests: XCTestCase {
    private var dumpPackageService: DumpPackageServiceMock {
        return DumpPackageServiceMock(fileURLMap: [
            URL.Mock.root: Bundle.module.url(forMockDumpPackageNamed: "root"),
            URL.Mock.hexColor: Bundle.module.url(forMockDumpPackageNamed: "hexcolor")
        ])
    }

    func testParsesName() throws {
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.root)
        XCTAssertEqual(swiftPackageFile.name, "ScriptBrowserFeature")
    }

    func testParsesTargetNames() throws {
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.root)
        let targetNames = swiftPackageFile.targets.map(\.name)
        XCTAssertEqual(targetNames, [
            "ScriptBrowserEntities",
            "ScriptBrowserGroupsService",
            "ScriptBrowserGroupsServiceMock",
            "ScriptBrowserListService",
            "ScriptBrowserListServiceLive",
            "ScriptBrowserListServiceFactory",
            "ScriptBrowserListServiceFactoryLive",
            "ScriptBrowserSearchService",
            "ScriptBrowserSidebarService",
            "ScriptBrowserSidebarServiceLive",
            "ScriptBrowserUI",
            "ScriptBrowserUITests"
        ])
    }

    // swiftlint:disable:next function_body_length
    func testParsesTargets() throws {
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.root)
        XCTAssertEqual(swiftPackageFile.targets, [
            .init(name: "ScriptBrowserEntities", dependencies: []),
            .init(name: "ScriptBrowserGroupsService", dependencies: [
                .name("ScriptBrowserEntities")
            ]),
            .init(name: "ScriptBrowserGroupsServiceMock", dependencies: [
                .name("ScriptBrowserEntities"),
                .name("ScriptBrowserGroupsService")
            ]),
            .init(name: "ScriptBrowserListService", dependencies: [
                .name("ScriptBrowserEntities")
            ]),
            .init(name: "ScriptBrowserListServiceLive", dependencies: [
                .name("ScriptBrowserEntities"),
                .name("ScriptBrowserGroupsService"),
                .name("ScriptBrowserListService"),
                .name("ScriptBrowserSearchService")
            ]),
            .init(name: "ScriptBrowserListServiceFactory", dependencies: [
                .name("ScriptBrowserEntities"),
                .name("ScriptBrowserListService")
            ]),
            .init(name: "ScriptBrowserListServiceFactoryLive", dependencies: [
                .name("ScriptBrowserEntities"),
                .name("ScriptBrowserGroupsService"),
                .name("ScriptBrowserListServiceFactory"),
                .name("ScriptBrowserListService"),
                .name("ScriptBrowserListServiceLive"),
                .name("ScriptBrowserSearchService")
            ]),
            .init(name: "ScriptBrowserSearchService", dependencies: []),
            .init(name: "ScriptBrowserSidebarService", dependencies: [
                .name("ScriptBrowserEntities")
            ]),
            .init(name: "ScriptBrowserSidebarServiceLive", dependencies: [
                .name("ScriptBrowserGroupsService"),
                .name("ScriptBrowserSidebarService")
            ]),
            .init(name: "ScriptBrowserUI", dependencies: [
                .name("ScriptBrowserEntities"),
                .name("ScriptBrowserListService"),
                .name("ScriptBrowserListServiceFactory"),
                .name("ScriptBrowserSidebarService"),
                .product("ColorCategories", inPackage: "HexColor")
            ]),
            .init(name: "ScriptBrowserUITests", dependencies: [
                .name("ScriptBrowserEntities"),
                .name("ScriptBrowserGroupsService"),
                .name("ScriptBrowserGroupsServiceMock"),
                .name("ScriptBrowserListService"),
                .name("ScriptBrowserListServiceFactory"),
                .name("ScriptBrowserListServiceLive"),
                .name("ScriptBrowserSearchService"),
                .name("ScriptBrowserSidebarServiceLive"),
                .name("ScriptBrowserUI")
            ])
        ])
    }

    func testParsesDependencies() throws {
        let parser = PackageSwiftFileParserLive(dumpPackageService: dumpPackageService)
        let swiftPackageFile = try parser.parseFile(at: URL.Mock.root)
        XCTAssertEqual(swiftPackageFile.dependencies, [
            .sourceControl(identity: "runestone"),
            .fileSystem(
                identity: "hexcolor",
                path: "/Users/simon/Developer/Foo/HexColor",
                packageSwiftFile: PackageSwiftFile(
                    name: "HexColor",
                    targets: [
                        .init(name: "ColorCategories"),
                        .init(name: "ColorCategoriesTests", dependencies: [
                            .name("ColorCategories")
                        ])
                    ]
                )
            )
        ])
    }
}

private extension URL {
    enum Mock {
        static var root: URL {
            return URL(filePath: "/Users/simon/Developer/Foo/root/Package.swift")
        }

        static var hexColor: URL {
            return URL(filePath: "/Users/simon/Developer/Foo/HexColor/Package.swift")
        }
    }
}

private extension Bundle {
    func url(forMockDumpPackageNamed filename: String) -> URL {
        return url(forResource: "MockData/" + filename, withExtension: "json")!
    }
}
