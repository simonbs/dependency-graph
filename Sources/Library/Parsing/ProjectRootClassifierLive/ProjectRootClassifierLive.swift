import FileSystem
import Foundation
import ProjectRootClassifier

public struct ProjectRootClassifierLive: ProjectRootClassifier {
    private let fileSystem: FileSystem

    public init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
    }

    public func classifyProject(at fileURL: URL) -> ProjectRoot {
        if fileURL.pathExtension == "xcodeproj" {
            return .xcodeproj(fileURL)
        } else if fileURL.lastPathComponent == "Package.swift" {
            return .packageSwiftFile(fileURL)
        } else {
            return .unknown
        }
    }
}
