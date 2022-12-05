import Foundation

extension XcodeProject {
    public struct Target: Equatable {
        public let name: String
        public let packageProductDependencies: [String]

        public init(name: String, packageProductDependencies: [String]) {
            self.name = name
            self.packageProductDependencies = packageProductDependencies
        }
    }
}
