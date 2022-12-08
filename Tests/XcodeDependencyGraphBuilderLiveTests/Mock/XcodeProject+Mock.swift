import Foundation
import XcodeProject

extension XcodeProject {
    static var mock: XcodeProject {
        return XcodeProject(name: "Example.xcodeproj", targets: [
            XcodeProject.Target(name: "Example", packageProductDependencies: [
                "ExampleLibraryA",
                "ExampleLibraryB",
                "RemoteA",
                "RemoteBFoo",
                "RemoteBBar"
            ]),
            XcodeProject.Target(name: "ExampleTests"),
            XcodeProject.Target(name: "ExampleUITests")
        ], swiftPackages: [
            .local(name: "ExamplePackageA", fileURL: URL.Mock.examplePackageA),
            .local(name: "ExamplePackageB", fileURL: URL.Mock.examplePackageB),
            .remote(name: "RemoteA", repositoryURL: URL(string: "https://github.com/simonbs/RemoteA")!, products: [
                "RemoteA"
            ]),
            .remote(name: "RemoteB", repositoryURL: URL(string: "git@github.com:simonbs/RemoteB.git")!, products: [
                "RemoteBFoo",
                "RemoteBBar"
            ])
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
