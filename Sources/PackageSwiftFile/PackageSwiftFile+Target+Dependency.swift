public extension PackageSwiftFile.Target {
    enum Dependency: Equatable {
        public struct NameParameters: Equatable {
            public let name: String

            public init(name: String) {
                self.name = name
            }
        }

        public struct ProductInPackageParameters: Equatable {
            public let name: String
            public let packageName: String

            public init(name: String, packageName: String) {
                self.name = name
                self.packageName = packageName
            }
        }

        case name(NameParameters)
        case productInPackage(ProductInPackageParameters)

        public static func name(_ name: String) -> Self {
            return .name(.init(name: name))
        }

        public static func product(_ name: String, inPackage package: String) -> Self {
            return .productInPackage(.init(name: name, packageName: package))
        }
    }
}
