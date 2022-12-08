// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphDeps",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "graph-deps", targets: ["Main"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.8.0"))
    ],
    targets: [
        .executableTarget(name: "Main", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "DOTGraphTransformer",
            "DOTGraphTransformerLive",
            "DumpPackageService",
            "DumpPackageServiceLive",
            "FileExistenceChecker",
            "FileExistenceCheckerLive",
            "GraphCommand",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserLive",
            "ProjectRootClassifier",
            "ProjectRootClassifierLive",
            "ShellCommandRunner",
            "ShellCommandRunnerLive",
            "XcodeDependencyGraphBuilder",
            "XcodeDependencyGraphBuilderLive",
            "XcodeProjectParser",
            "XcodeProjectParserLive"
        ]),
        .target(name: "DirectedGraph"),
        .target(name: "DOTGraphTransformer", dependencies: [
            "DirectedGraph"
        ]),
        .target(name: "DOTGraphTransformerLive", dependencies: [
            "DOTGraphTransformer",
            "DirectedGraph"
        ]),
        .target(name: "DumpPackageService"),
        .target(name: "DumpPackageServiceLive", dependencies: [
            "DumpPackageService",
            "ShellCommandRunner"
        ]),
        .target(name: "FileExistenceChecker"),
        .target(name: "FileExistenceCheckerLive", dependencies: [
            "FileExistenceChecker"
        ]),
        .target(name: "GraphCommand", dependencies: [
            "DOTGraphTransformer",
            "ProjectRootClassifier",
            "XcodeProjectParser",
            "XcodeDependencyGraphBuilder"
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
        .target(name: "ProjectRootClassifier"),
        .target(name: "ProjectRootClassifierLive", dependencies: [
            "FileExistenceChecker",
            "ProjectRootClassifier"
        ]),
        .target(name: "ShellCommandRunner"),
        .target(name: "ShellCommandRunnerLive", dependencies: [
            "ShellCommandRunner"
        ]),
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
            "FileExistenceChecker",
            .product(name: "XcodeProj", package: "XcodeProj"),
            "XcodeProject",
            "XcodeProjectParser"
        ]),
        .testTarget(name: "DOTGraphTransformerLiveTests", dependencies: [
            "DirectedGraph",
            "DOTGraphTransformerLive"
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
