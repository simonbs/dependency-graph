import Foundation
import ProjectRootClassifier

struct ProjectRootClassifierMock: ProjectRootClassifier {
    func classifyProject(at fileURL: URL) -> ProjectRoot {
        return .xcodeproj(fileURL)
    }
}
