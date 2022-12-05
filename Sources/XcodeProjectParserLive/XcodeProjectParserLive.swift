import Foundation
import PackageSwiftFileParser
import PathKit
import XcodeProj
import XcodeProject
import XcodeProjectParser

public struct XcodeProjectParserLive: XcodeProjectParser {
    private let packageSwiftFileParser: PackageSwiftFileParser

    public init(packageSwiftFileParser: PackageSwiftFileParser) {
        self.packageSwiftFileParser = packageSwiftFileParser
    }

    public func parseProject(at fileURL: URL) throws -> XcodeProject {
        let path = Path(fileURL.relativePath)
        let project = try XcodeProj(path: path)
        let sourceRoot = fileURL.deletingLastPathComponent()
        let remoteSwiftPackages = remoteSwiftPackages(in: project)
        let localSwiftPackages = try localSwiftPackages(in: project, atSourceRoot: sourceRoot)
        return XcodeProject(
            name: fileURL.lastPathComponent,
            targets: targets(in: project),
            swiftPackages: remoteSwiftPackages + localSwiftPackages
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
        return project.pbxproj.nativeTargets.reduce(into: []) { targetResult, target in
            targetResult += target.dependencies.reduce(into: []) { dependencyResult, dependency in
                guard let package = dependency.product?.package, let packageName = package.name else {
                    return
                }
                guard let rawRepositoryURL = package.repositoryURL, let repositoryURL = URL(string: rawRepositoryURL) else {
                    return
                }
                dependencyResult.append(.remote(.init(name: packageName, repositoryURL: repositoryURL)))
            }
        }
    }

    func localSwiftPackages(in project: XcodeProj, atSourceRoot sourceRoot: URL) throws -> [XcodeProject.SwiftPackage] {
        return []
    }
}
