import Foundation

public extension XcodeProject {
    enum SwiftPackage {
        public struct LocalParameters {
            public let name: String
            public let fileURL: URL

            public init(name: String, fileURL: URL) {
                self.name = name
                self.fileURL = fileURL
            }
        }

        public struct RemoteParameters {
            public let name: String
            public let repositoryURL: URL

            public init(name: String, repositoryURL: URL) {
                self.name = name
                self.repositoryURL = repositoryURL
            }
        }

        case local(LocalParameters)
        case remote(RemoteParameters)
    }
}
