import Foundation
import PackageSwiftFile
import PackageSwiftFileParser

struct PackageSwiftFileMapper {
    private let packageSwiftFileParser: PackageSwiftFileParser

    init(packageSwiftFileParser: PackageSwiftFileParser) {
        self.packageSwiftFileParser = packageSwiftFileParser
    }

    func map(_ intermediate: IntermediatePackageSwiftFile) throws -> PackageSwiftFile {
        let targets = intermediate.targets.map(map)
        let dependencies = try intermediate.dependencies.map(map)
        return PackageSwiftFile(name: intermediate.name, targets: targets, dependencies: dependencies)
    }
}

private extension PackageSwiftFileMapper {
    private func map(_ intermediate: IntermediatePackageSwiftFile.Target) -> PackageSwiftFile.Target {
        let dependencies = intermediate.dependencies.map(map)
        return PackageSwiftFile.Target(name: intermediate.name, dependencies: dependencies)
    }

    private func map(_ intermediate: IntermediatePackageSwiftFile.Target.Dependency) -> PackageSwiftFile.Target.Dependency {
        switch intermediate {
        case .byName(let parameters):
            return .name(parameters.name)
        case .product(let parameters):
            return .product(parameters.name, inPackage: parameters.package)
        }
    }

    private func map(_ intermediate: IntermediatePackageSwiftFile.Dependency) throws -> PackageSwiftFile.Dependency {
        switch intermediate {
        case .sourceControl(let parameters):
            return .sourceControl(identity: parameters.identity)
        case .fileSystem(let parameters):
            let fileURL = URL(filePath: parameters.path).appending(path: "Package.swift")
            let packageSwiftFile = try packageSwiftFileParser.parseFile(at: fileURL)
            return .fileSystem(identity: parameters.identity, path: parameters.path, packageSwiftFile: packageSwiftFile)
        }
    }
}
