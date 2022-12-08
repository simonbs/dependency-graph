struct IntermediatePackageSwiftFile: Decodable {
    let name: String
    let products: [Product]
    let targets: [Target]
    let dependencies: [Dependency]
}
