import Foundation
import PathKit
import XcodeProj
import XcodeProject
import XcodeProjectParser

public struct XcodeProjectParserLive: XcodeProjectParser {
    public init() {}

    public func parseProject(at fileURL: URL) throws -> XcodeProject {
        let path = Path(fileURL.relativePath)
        let project = try XcodeProj(path: path)
        let sourceRoot = fileURL.deletingLastPathComponent()
        let remoteSwiftPackages = remoteSwiftPackages(in: project)
        let localSwiftPackages = try localSwiftPackages(in: project, atSourceRoot: sourceRoot)
        return XcodeProject(
            name: fileURL.lastPathComponent,
            targets: targets(in: project),
            swiftPackages: (remoteSwiftPackages + localSwiftPackages)
        )
    }
}

private extension XcodeProjectParserLive {
    func targets(in project: XcodeProj) -> [XcodeProject.Target] {
        return project.pbxproj.nativeTargets.map { target in
            let packageProductDependencies = target.packageProductDependencies.map(\.productName)
            return .init(name: target.name, packageProductDependencies: packageProductDependencies)
        }
    }

    func remoteSwiftPackages(in project: XcodeProj) -> [XcodeProject.SwiftPackage] {
        struct IntermediateRemoteSwiftPackage {
            let name: String
            let repositoryURL: URL
            let products: [String]
        }
        var swiftPackages: [IntermediateRemoteSwiftPackage] = []
        for target in project.pbxproj.nativeTargets {
            for dependency in target.packageProductDependencies {
                guard let package = dependency.package, let packageName = package.name else {
                    continue
                }
                guard let rawRepositoryURL = package.repositoryURL, let repositoryURL = URL(string: rawRepositoryURL) else {
                    continue
                }
                if let existingSwiftPackageIndex = swiftPackages.firstIndex(where: { $0.name == packageName }) {
                    let existingSwiftPackage = swiftPackages[existingSwiftPackageIndex]
                    let newProducts = existingSwiftPackage.products + [dependency.productName]
                    let newSwiftPackage = IntermediateRemoteSwiftPackage(name: packageName, repositoryURL: repositoryURL, products: newProducts)
                    swiftPackages[existingSwiftPackageIndex] = newSwiftPackage
                } else {
                    let products = [dependency.productName]
                    let swiftPackage = IntermediateRemoteSwiftPackage(name: packageName, repositoryURL: repositoryURL, products: products)
                    swiftPackages.append(swiftPackage)
                }
            }
        }
        return swiftPackages.map { .remote(name: $0.name, repositoryURL: $0.repositoryURL, products: $0.products) }
    }

    func localSwiftPackages(in project: XcodeProj, atSourceRoot sourceRoot: URL) throws -> [XcodeProject.SwiftPackage] {
        return project.pbxproj.fileReferences.compactMap { fileReference in
            guard fileReference.isPotentialSwiftPackage else {
                return nil
            }
            guard let packageName = fileReference.potentialPackageName else {
                return nil
            }
            guard let packageSwiftFileURL = fileReference.potentialPackageSwiftFileURL(forSourceRoot: sourceRoot) else {
                return nil
            }
            guard FileManager.default.fileExists(atPath: packageSwiftFileURL.relativePath) else {
                return nil
            }
            return .local(.init(name: packageName, fileURL: packageSwiftFileURL))
        }
    }
}

private extension PBXFileReference {
    var isPotentialSwiftPackage: Bool {
        return lastKnownFileType == "folder" || lastKnownFileType == "wrapper"
    }

    var potentialPackageName: String? {
        return name ?? path
    }

    func potentialPackageSwiftFileURL(forSourceRoot sourceRoot: URL) -> URL? {
        guard let path = path else {
            return nil
        }
        return sourceRoot.appending(path: path).appending(path: "Package.swift")
    }
}
