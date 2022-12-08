import Foundation

public protocol ProjectRootClassifier {
    func classifyProject(at fileURL: URL) -> ProjectRoot
}
