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
            "Graph",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserLive",
            "ShellCommandRunner",
            "ShellCommandRunnerLive",
            "XcodeProjectParser",
            "XcodeProjectParserLive"
        ]),
        .target(name: "Graph"),
        .target(name: "PackageSwiftFileParser"),
        .target(name: "PackageSwiftFileParserLive", dependencies: [
            "DumpPackageService",
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
        .target(name: "XcodeProjectParser"),
        .target(name: "XcodeProjectParserLive", dependencies: [
            .product(name: "XcodeProj", package: "XcodeProj"),
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
        ], resources: [.copy("MockData")])
    ]
)
