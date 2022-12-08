import Foundation
import XcodeProject

extension XcodeProject {
    static var mock: XcodeProject {
        return XcodeProject(name: "Example.xcodeproj", targets: [
            XcodeProject.Target(name: "Example", packageProductDependencies: [
                "ExampleLibraryA",
                "ExampleLibraryB"
            ]),
            XcodeProject.Target(name: "ExampleTests"),
            XcodeProject.Target(name: "ExampleUITests")
        ], swiftPackages: [
            .local(name: "ExamplePackageA", fileURL: URL.Mock.examplePackageA),
            .local(name: "ExamplePackageB", fileURL: URL.Mock.examplePackageB)
        ])
    }

    static var mockWithMissingDependency: XcodeProject {
        return XcodeProject(name: "Example.xcodeproj", targets: [
            XcodeProject.Target(name: "Example", packageProductDependencies: [
                "ExampleLibraryA"
            ])
        ])
    }
}
