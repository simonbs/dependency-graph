extension IntermediatePackageSwiftFile {
    enum Dependency: Decodable {
        private enum CodingKeys: String, CodingKey {
            case sourceControl
            case fileSystem
        }

        struct SourceControlParameters: Decodable {
            let identity: String
        }

        struct FileSystemParameters: Decodable {
            let identity: String
            let path: String
        }

        case sourceControl(SourceControlParameters)
        case fileSystem(FileSystemParameters)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.allKeys.contains(CodingKeys.sourceControl) {
                self = try .decodeSourceControl(using: container)
            } else if container.allKeys.contains(CodingKeys.fileSystem) {
                self = try .decodeFileSystem(using: container)
            } else {
                let keysString = container.allKeys.map(\.stringValue).joined(separator: ", ")
                let debugDescription = "Unsupported keys: " + keysString
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
            }
        }
    }
}

private extension IntermediatePackageSwiftFile.Dependency {
    private static func decodeSourceControl(using container: KeyedDecodingContainer<Self.CodingKeys>) throws -> Self {
        let parametersContainer = try container.decode([SourceControlParameters].self, forKey: .sourceControl)
        guard parametersContainer.count == 1 else {
            let debugDescription = "Expected to decode exactly 1 parameter object but found \(parametersContainer.count)"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        return .sourceControl(parametersContainer[0])
    }

    private static func decodeFileSystem(using container: KeyedDecodingContainer<Self.CodingKeys>) throws -> Self {
        let parametersContainer = try container.decode([FileSystemParameters].self, forKey: .fileSystem)
        guard parametersContainer.count == 1 else {
            let debugDescription = "Expected to decode exactly 1 parameter object but found \(parametersContainer.count)"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        return .fileSystem(parametersContainer[0])
    }
}
