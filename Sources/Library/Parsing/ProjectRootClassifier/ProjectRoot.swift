import Foundation

public enum ProjectRoot: Equatable {
    case xcodeproj(URL)
    case packageSwiftFile(URL)
    case unknown
}
