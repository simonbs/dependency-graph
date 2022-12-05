public struct PackageSwiftFile: Equatable {
    public let name: String
    public let targets: [Target]
    public let dependencies: [Dependency]

    public init(name: String, targets: [Target] = [], dependencies: [Dependency] = []) {
        self.name = name
        self.targets = targets
        self.dependencies = dependencies
    }
}
