public struct PackageSwiftFile: Equatable {
    public let name: String
    public let products: [Product]
    public let targets: [Target]
    public let dependencies: [Dependency]

    public init(name: String, products: [Product] = [], targets: [Target] = [], dependencies: [Dependency] = []) {
        self.name = name
        self.products = products
        self.targets = targets
        self.dependencies = dependencies
    }
}
