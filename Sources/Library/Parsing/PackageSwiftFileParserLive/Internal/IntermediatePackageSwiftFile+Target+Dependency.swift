extension IntermediatePackageSwiftFile.Target {
    enum Dependency: Decodable {
        private enum CodingKeys: CodingKey {
            case byName
            case product
        }

        struct ByNameParameters {
            let name: String
        }

        struct ProductParameters {
            let name: String
            let package: String
        }

        case byName(ByNameParameters)
        case product(ProductParameters)

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.allKeys.contains(CodingKeys.byName) {
                self = try .decodeByName(using: container)
            } else if container.allKeys.contains(CodingKeys.product) {
                self = try .decodeProduct(using: container)
            } else {
                let keysString = container.allKeys.map(\.stringValue).joined(separator: ", ")
                let debugDescription = "Unsupported keys: " + keysString
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
            }
        }
    }
}

private extension IntermediatePackageSwiftFile.Target.Dependency {
    private static func decodeByName(using container: KeyedDecodingContainer<Self.CodingKeys>) throws -> Self {
        let values = try container.decode([String?].self, forKey: .byName)
        guard values.count >= 1 else {
            let debugDescription = "Expected to decode at least 1 string but found \(values.count)"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        guard case let .some(name) = values[0] else {
            let debugDescription = "Expected library name to be non-null"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        let parameters = ByNameParameters(name: name)
        return .byName(parameters)
    }

    private static func decodeProduct(using container: KeyedDecodingContainer<Self.CodingKeys>) throws -> Self {
        let values = try container.decode([String?].self, forKey: .product)
        guard values.count >= 2 else {
            let debugDescription = "Expected to decode at least 2 strings but found \(values.count)"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        guard case let .some(name) = values[0] else {
            let debugDescription = "Expected library name to be non-null"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        guard case let .some(package) = values[1] else {
            let debugDescription = "Expected package name to be non-null"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        let parameters = ProductParameters(name: name, package: package)
        return .product(parameters)
    }
}
