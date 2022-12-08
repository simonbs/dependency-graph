public extension PackageSwiftFile {
    struct Target: Equatable {
        public let name: String
        public let dependencies: [Dependency]

        public init(name: String, dependencies: [Dependency] = []) {
            self.name = name
            self.dependencies = dependencies
        }
    }
}
