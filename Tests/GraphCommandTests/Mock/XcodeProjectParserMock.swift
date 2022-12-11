import Foundation
import XcodeProject
import XcodeProjectParser

struct XcodeProjectParserMock: XcodeProjectParser {
    func parseProject(at fileURL: URL) throws -> XcodeProject {
        return XcodeProject(name: "Example")
    }
}
