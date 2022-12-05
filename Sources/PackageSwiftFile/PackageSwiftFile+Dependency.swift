extension PackageSwiftFile {
    public enum Dependency: Equatable {
        public struct SourceControlParameters: Equatable {
            public let identity: String

            public init(identity: String) {
                self.identity = identity
            }
        }

        public struct FileSystemParameters: Equatable {
            public let identity: String
            public let path: String
            public let packageSwiftFile: PackageSwiftFile

            public init(identity: String, path: String, packageSwiftFile: PackageSwiftFile) {
                self.identity = identity
                self.path = path
                self.packageSwiftFile = packageSwiftFile
            }
        }

        case sourceControl(SourceControlParameters)
        case fileSystem(FileSystemParameters)

        public static func sourceControl(identity: String) -> Self {
            let parameters = SourceControlParameters(identity: identity)
            return .sourceControl(parameters)
        }

        public static func fileSystem(identity: String, path: String, packageSwiftFile: PackageSwiftFile) -> Self {
            let parameters = FileSystemParameters(identity: identity, path: path, packageSwiftFile: packageSwiftFile)
            return .fileSystem(parameters)
        }
    }
}
