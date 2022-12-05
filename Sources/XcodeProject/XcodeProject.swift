import Foundation

public struct XcodeProject: Equatable {
    public let name: String
    public let targets: [Target]
    public let swiftPackages: [SwiftPackage]

    public init(name: String, targets: [Target] = [], swiftPackages: [SwiftPackage] = []) {
        self.name = name
        self.targets = targets
        self.swiftPackages = swiftPackages
    }
}
