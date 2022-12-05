import Foundation

public protocol XcodeProjectParser {
    func parseProject(at fileURL: URL) throws -> XcodeProject
}
