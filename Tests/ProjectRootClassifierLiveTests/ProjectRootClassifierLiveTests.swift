import Foundation
@testable import ProjectRootClassifierLive
import XCTest

final class ProjectRootClassifierLiveTests: XCTestCase {
    func testClassifiesPathToProject() {
        let fileSystem = FileSystemMock()
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let fileURL = URL(filePath: "/Users/simon/Developer/Example/Example.xcodeproj")
        let projectRoot = classifier.classifyProject(at: fileURL)
        XCTAssertEqual(projectRoot, .xcodeproj(fileURL))
    }

    func testClassifiesPathToPackageSwiftFile() {
        let fileSystem = FileSystemMock()
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let fileURL = URL(filePath: "/Users/simon/Developer/Example/Package.swift")
        let projectRoot = classifier.classifyProject(at: fileURL)
        XCTAssertEqual(projectRoot, .packageSwiftFile(fileURL))
    }

    func testClassifiesDirectoryContainingXcodeproj() {
        let fileSystem = FileSystemMock()
        fileSystem.isDirectory = true
        fileSystem.directoryContents = [".gitignore", "README.md", "Example.xcodeproj"]
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let directoryURL = URL(filePath: "/Users/simon/Developer/Example")
        let expectedFileURL = URL(filePath: "/Users/simon/Developer/Example/Example.xcodeproj")
        let projectRoot = classifier.classifyProject(at: directoryURL)
        XCTAssertEqual(projectRoot, .xcodeproj(expectedFileURL))
    }

    func testClassifiesDirectoryContainingPackageSwiftFile() {
        let fileSystem = FileSystemMock()
        fileSystem.isDirectory = true
        fileSystem.directoryContents = [".gitignore", "README.md", "Package.swift"]
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let directoryURL = URL(filePath: "/Users/simon/Developer/Example")
        let expectedFileURL = URL(filePath: "/Users/simon/Developer/Example/Package.swift")
        let projectRoot = classifier.classifyProject(at: directoryURL)
        XCTAssertEqual(projectRoot, .packageSwiftFile(expectedFileURL))
    }

    func testFailsClassifyingUnknownFile() {
        let fileSystem = FileSystemMock()
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let directoryURL = URL(filePath: "/Users/simon/Developer/Example/README.md")
        let projectRoot = classifier.classifyProject(at: directoryURL)
        XCTAssertEqual(projectRoot, .unknown)
    }

    func testFailsClassifyingDirectoryContainingUnknownFiles() {
        let fileSystem = FileSystemMock()
        fileSystem.isDirectory = true
        fileSystem.directoryContents = [".gitignore", "README.md"]
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let directoryURL = URL(filePath: "/Users/simon/Developer/Example")
        let projectRoot = classifier.classifyProject(at: directoryURL)
        XCTAssertEqual(projectRoot, .unknown)
    }

    func testFailsClassifyingNonExistingFile() {
        let fileSystem = FileSystemMock()
        fileSystem.fileExists = false
        fileSystem.directoryContents = [".gitignore", "README.md"]
        let classifier = ProjectRootClassifierLive(fileSystem: fileSystem)
        let directoryURL = URL(filePath: "/Users/simon/Developer/Example/README.md")
        let projectRoot = classifier.classifyProject(at: directoryURL)
        XCTAssertEqual(projectRoot, .unknown)
    }
}
