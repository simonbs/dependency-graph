import FileExistenceChecker
import Foundation
import ProjectRootClassifier

public struct ProjectRootClassifierLive: ProjectRootClassifier {
    private let fileExistenceChecker: FileExistenceChecker

    public init(fileExistenceChecker: FileExistenceChecker) {
        self.fileExistenceChecker = fileExistenceChecker
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
