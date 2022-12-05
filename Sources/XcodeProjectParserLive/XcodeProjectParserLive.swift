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
            targets: targets(in: project).sorted { $0.name < $1.name },
            swiftPackages: (remoteSwiftPackages + localSwiftPackages).sorted { $0.name < $1.name }
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
            targetResult += target.packageProductDependencies.compactMap { dependency in
                guard let package = dependency.package, let packageName = package.name else {
                    return nil
                }
                guard let rawRepositoryURL = package.repositoryURL, let repositoryURL = URL(string: rawRepositoryURL) else {
                    return nil
                }
                return .remote(.init(name: packageName, repositoryURL: repositoryURL))
            }
        }
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
