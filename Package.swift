// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphDeps",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "graph-deps", targets: ["GraphDeps"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.8.0"))
    ],
    targets: [
        .executableTarget(name: "GraphDeps", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "DumpPackageService",
            "DumpPackageServiceLive",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserLive",
            "ShellCommandRunner",
            "ShellCommandRunnerLive",
            "XcodeProjectParser",
            "XcodeProjectParserLive"
        ]),
        .target(name: "PackageSwiftFile"),
        .target(name: "PackageSwiftFileParser", dependencies: [
            "PackageSwiftFile"
        ]),
        .target(name: "PackageSwiftFileParserLive", dependencies: [
            "DumpPackageService",
            "PackageSwiftFile",
            "PackageSwiftFileParser"
        ]),
        .target(name: "DumpPackageService"),
        .target(name: "DumpPackageServiceLive", dependencies: [
            "DumpPackageService",
            "ShellCommandRunner"
        ]),
        .target(name: "ShellCommandRunner"),
        .target(name: "ShellCommandRunnerLive", dependencies: [
            "ShellCommandRunner"
        ]),
        .target(name: "DirectedGraph"),
        .target(name: "XcodeDependencyGraphBuilder", dependencies: [
            "DirectedGraph",
            "XcodeProject"
        ]),
        .target(name: "XcodeDependencyGraphBuilderLive", dependencies: [
            "DirectedGraph",
            "PackageSwiftFile",
            "PackageSwiftFileParser",
            "XcodeDependencyGraphBuilder",
            "XcodeProject"
        ]),
        .target(name: "XcodeProject"),
        .target(name: "XcodeProjectParser", dependencies: [
            "XcodeProject"
        ]),
        .target(name: "XcodeProjectParserLive", dependencies: [
            .product(name: "XcodeProj", package: "XcodeProj"),
            "XcodeProject",
            "XcodeProjectParser"
        ]),
        .testTarget(name: "DumpPackageServiceLiveTests", dependencies: [
            "DumpPackageServiceLive",
            "ShellCommandRunner"
        ]),
        .testTarget(name: "PackageSwiftFileParserLiveTests", dependencies: [
            "DumpPackageService",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserLive"
        ], resources: [.copy("MockData")]),
        .testTarget(name: "XcodeDependencyGraphBuilderLiveTests", dependencies: [
            "DirectedGraph",
            "PackageSwiftFileParser",
            "XcodeDependencyGraphBuilderLive",
            "XcodeProject"
        ]),
        .testTarget(name: "XcodeProjectParserLiveTests", dependencies: [
            "XcodeProject",
            "XcodeProjectParserLive"
        ], resources: [.copy("Example")])
    ]
)
