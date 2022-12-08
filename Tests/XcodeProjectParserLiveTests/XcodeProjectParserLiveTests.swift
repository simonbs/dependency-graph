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
        let exampleTarget = xcodeProject.targets.first { $0.name == "Example" }
        let exampleTestsTarget = xcodeProject.targets.first { $0.name == "ExampleTests" }
        let exampleUITestsTarget = xcodeProject.targets.first { $0.name == "ExampleUITests" }
        XCTAssertNotNil(exampleTarget)
        XCTAssertNotNil(exampleTestsTarget)
        XCTAssertNotNil(exampleUITestsTarget)
    }

    func testParsesTargetPackageProductDependencies() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        let exampleTarget = xcodeProject.targets.first { $0.name == "Example" }
        let packageProductDependencies = exampleTarget?.packageProductDependencies ?? []
        XCTAssertTrue(packageProductDependencies.contains("Runestone"))
        XCTAssertTrue(packageProductDependencies.contains("TreeSitterJavaScriptRunestone"))
        XCTAssertTrue(packageProductDependencies.contains("ExampleLibraryA"))
        XCTAssertTrue(packageProductDependencies.contains("ExampleLibraryB"))
    }

    func testSwiftPackageCount() throws {
        let parser = XcodeProjectParserLive()
        let xcodeProject = try parser.parseProject(at: URL.Mock.exampleXcodeProject)
        print(xcodeProject.swiftPackages)
        XCTAssertEqual(xcodeProject.swiftPackages.count, 4)
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
        let runestoneSwiftPackage = xcodeProject.swiftPackages.first { $0.name == "Runestone" }
        let treeSitterSwiftPackage = xcodeProject.swiftPackages.first { $0.name == "TreeSitterLanguages" }
        XCTAssertNotNil(runestoneSwiftPackage)
        XCTAssertNotNil(treeSitterSwiftPackage)
        if case let .remote(parameters) = runestoneSwiftPackage {
            XCTAssertEqual(parameters.name, "Runestone")
            XCTAssertEqual(parameters.repositoryURL, URL(string: "https://github.com/simonbs/Runestone"))
            XCTAssertEqual(parameters.products, ["Runestone"])
        } else {
            XCTFail("Expected Runestone to be a remote package")
        }
        if case let .remote(parameters) = treeSitterSwiftPackage {
            XCTAssertEqual(parameters.name, "TreeSitterLanguages")
            XCTAssertEqual(parameters.repositoryURL, URL(string: "git@github.com:simonbs/TreeSitterLanguages.git"))
            XCTAssertEqual(parameters.products, ["TreeSitterJSONRunestone", "TreeSitterJavaScriptRunestone"])
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
