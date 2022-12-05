@testable import XcodeProject
@testable import XcodeProjectParserLive
import XCTest

final class XcodeProjectParserLiveTests: XCTestCase {
    func testParsesProjectName() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        XCTAssertEqual(xcodeProject.name, "Example.xcodeproj")
    }

    func testParsesTargets() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        XCTAssertEqual(xcodeProject.targets, [
            .init(name: "Example", packageProductDependencies: ["Runestone"]),
            .init(name: "ExampleTests", packageProductDependencies: []),
            .init(name: "ExampleUITests", packageProductDependencies: [])
        ])
    }

    func testSwiftPackageCount() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        XCTAssertEqual(xcodeProject.swiftPackages.count, 3)
    }

    func testParsesLocalSwiftPackage() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        let swiftPackage = xcodeProject.swiftPackages.first { $0.name == "ExamplePackageA" }
        XCTAssertNotNil(swiftPackage)
        if case let .local(parameters)  = swiftPackage {
            XCTAssertEqual(parameters.name, "ExamplePackageA")
            let fileURLHasPackageSwiftSuffix = parameters.fileURL.absoluteString.hasSuffix("ExamplePackageA/Package.swift")
            XCTAssertTrue(fileURLHasPackageSwiftSuffix, "Expected file URL to end with the package name and Package.swift")
        } else {
            XCTFail("Expected ExamplePackageA to be a local package")
        }
    }

    func testParsesRemoteSwiftPackage() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        let swiftPackage = xcodeProject.swiftPackages.first { $0.name == "Runestone" }
        XCTAssertNotNil(swiftPackage)
        if case let .remote(parameters)  = swiftPackage {
            XCTAssertEqual(parameters.name, "Runestone")
            XCTAssertEqual(parameters.repositoryURL, URL(string: "https://github.com/simonbs/Runestone"))
        } else {
            XCTFail("Expected Runestone to be a remote package")
        }
    }
}

private extension URL {
    enum Mock {
        static let exampleXcodeProject = Bundle.module.url(forResource: "Example/Example", withExtension: "xcodeproj")!
    }
}
