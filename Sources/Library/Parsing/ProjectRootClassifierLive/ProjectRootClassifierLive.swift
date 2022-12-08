import FileSystem
import Foundation
import ProjectRootClassifier

public struct ProjectRootClassifierLive: ProjectRootClassifier {
    private let fileSystem: FileSystem
    private let xcodeprojPathExtension = "xcodeproj"
    private let packageSwiftFilename = "Package.swift"

    public init(fileSystem: FileSystem) {
        self.fileSystem = fileSystem
    }

    public func classifyProject(at itemURL: URL) -> ProjectRoot {
        if itemURL.pathExtension == xcodeprojPathExtension {
            return .xcodeproj(itemURL)
        } else if itemURL.lastPathComponent == packageSwiftFilename {
            return .packageSwiftFile(itemURL)
        } else if fileSystem.isDirectory(at: itemURL) {
            return classifyDirectory(at: itemURL)
        } else {
            return .unknown
        }
    }
}

private extension ProjectRootClassifierLive {
    private func classifyDirectory(at directoryURL: URL) -> ProjectRoot {
        let filenames = fileSystem.contentsOfDirectory(at: directoryURL)
        if let filename = filenames.first(where: { $0.hasSuffix("." + xcodeprojPathExtension) }) {
            let xcodeprojFileURL = directoryURL.appending(path: filename)
            return .xcodeproj(xcodeprojFileURL)
        } else if filenames.contains(where: { $0 == packageSwiftFilename }) {
            let packageSwiftFileURL = directoryURL.appending(path: packageSwiftFilename)
            return .packageSwiftFile(packageSwiftFileURL)
        } else {
            return .unknown
        }
    }
}
