extension IntermediatePackageSwiftFile {
    struct Product: Decodable {
        let name: String
        let targets: [String]
    }
}
