import Foundation

public extension XcodeProject {
    enum SwiftPackage: Equatable {
        public struct LocalParameters: Equatable {
            public let name: String
            public let fileURL: URL

            public init(name: String, fileURL: URL) {
                self.name = name
                self.fileURL = fileURL
            }
        }

        public struct RemoteParameters: Equatable {
            public let name: String
            public let repositoryURL: URL
            public let products: [String]

            public init(name: String, repositoryURL: URL, products: [String] = []) {
                self.name = name
                self.repositoryURL = repositoryURL
                self.products = products
            }
        }

        case local(LocalParameters)
        case remote(RemoteParameters)

        public var name: String {
            switch self {
            case .local(let parameters):
                return parameters.name
            case .remote(let parameters):
                return parameters.name
            }
        }

        public static func local(name: String, fileURL: URL) -> Self {
            let parameters = LocalParameters(name: name, fileURL: fileURL)
            return .local(parameters)
        }

        public static func remote(name: String, repositoryURL: URL, products: [String] = []) -> Self {
            let parameters = RemoteParameters(name: name, repositoryURL: repositoryURL, products: products)
            return .remote(parameters)
        }
    }
}
