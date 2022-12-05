struct IntermediatePackageSwiftFile: Decodable {
    let name: String
    let targets: [Target]
    let dependencies: [Dependency]
}
