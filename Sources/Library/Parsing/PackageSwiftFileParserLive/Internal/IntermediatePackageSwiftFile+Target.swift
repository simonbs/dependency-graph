extension IntermediatePackageSwiftFile {
    struct Target: Decodable {
        let name: String
        let dependencies: [Dependency]
    }
}
