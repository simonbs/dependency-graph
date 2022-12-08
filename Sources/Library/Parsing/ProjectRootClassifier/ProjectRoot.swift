import Foundation

public enum ProjectRoot {
    case xcodeproj(URL)
    case packageSwiftFile(URL)
    case unknown
}
