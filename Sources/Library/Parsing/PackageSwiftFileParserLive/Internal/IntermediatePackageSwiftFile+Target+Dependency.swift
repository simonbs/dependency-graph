extension IntermediatePackageSwiftFile.Target {
    enum Dependency: Decodable {
        private enum CodingKeys: CodingKey {
            case byName
            case target
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
                self = try .decodeName(using: container, forKey: .byName)
            } else if container.allKeys.contains(CodingKeys.target) {
                self = try .decodeName(using: container, forKey: .target)
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
    private static func decodeName(using container: KeyedDecodingContainer<Self.CodingKeys>, forKey key: CodingKeys) throws -> Self {
        let values = try container.decode([NameComponent].self, forKey: key)
        guard values.count >= 1 else {
            let debugDescription = "Expected to decode at least 1 string but found \(values.count)"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        guard case let .string(name) = values[0] else {
            let debugDescription = "Expected library name to be non-null"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        let parameters = ByNameParameters(name: name)
        return .byName(parameters)
    }

    private static func decodeProduct(using container: KeyedDecodingContainer<Self.CodingKeys>) throws -> Self {
        let values = try container.decode([ProductComponent].self, forKey: .product)
        guard values.count >= 2 else {
            let debugDescription = "Expected to decode at least 2 strings but found \(values.count)"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        guard case let .string(name) = values[0] else {
            let debugDescription = "Expected library name to be non-null"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        guard case let .string(package) = values[1] else {
            let debugDescription = "Expected package name to be non-null"
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
        }
        let parameters = ProductParameters(name: name, package: package)
        return .product(parameters)
    }
}

extension IntermediatePackageSwiftFile.Target.Dependency {
    private enum NameComponent: Decodable {
        struct PlatformNamesContainer: Decodable {
            let platformNames: [String]
        }

        case string(String)
        case platformNamesContainer(PlatformNamesContainer)
        case null

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let str = try? container.decode(String.self) {
                self = .string(str)
            } else if let container = try? container.decode(PlatformNamesContainer.self) {
                self = .platformNamesContainer(container)
            } else if container.decodeNil() {
                self = .null
            } else {
                let debugDescription = "Unexpected byName component"
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
            }
        }
    }

    private enum ProductComponent: Decodable {
        case string(String)
        case condition(Condition)
        case null

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let str = try? container.decode(String.self) {
                self = .string(str)
            } else if let condition = try? container.decode(Condition.self) {
                self = .condition(condition)
            } else if container.decodeNil() {
                self = .null
            } else {
                let debugDescription = "Unexpected product component"
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: debugDescription))
            }
        }
    }
}

extension IntermediatePackageSwiftFile.Target.Dependency {
    struct Condition: Decodable {
        let platformNames: [String]
    }
}
