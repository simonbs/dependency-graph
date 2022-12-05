import Foundation
import XcodeProject

public protocol XcodeProjectParser {
    func parseProject(at fileURL: URL) throws -> XcodeProject
}
