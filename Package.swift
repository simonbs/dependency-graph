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
            "FileSystem",
            "FileSystemLive",
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

        // Sources/Library/Commands
        .target(name: "GraphCommand", dependencies: [
            "DOTGraphTransformer",
            "ProjectRootClassifier",
            "XcodeProjectParser",
            "XcodeDependencyGraphBuilder"
        ], path: "Sources/Library/Commands/GraphCommand"),

        // Sources/Library/Graphing
        .target(name: "DirectedGraph", path: "Sources/Library/Graphing/DirectedGraph"),
        .target(name: "DOTGraphTransformer", dependencies: [
            "DirectedGraph"
        ], path: "Sources/Library/Graphing/DOTGraphTransformer"),
        .target(name: "DOTGraphTransformerLive", dependencies: [
            "DOTGraphTransformer",
            "DirectedGraph"
        ], path: "Sources/Library/Graphing/DOTGraphTransformerLive"),
        .target(name: "XcodeDependencyGraphBuilder", dependencies: [
            "DirectedGraph",
            "XcodeProject"
        ], path: "Sources/Library/Graphing/XcodeDependencyGraphBuilder"),
        .target(name: "XcodeDependencyGraphBuilderLive", dependencies: [
            "DirectedGraph",
            "PackageSwiftFile",
            "PackageSwiftFileParser",
            "XcodeDependencyGraphBuilder",
            "XcodeProject"
        ], path: "Sources/Library/Graphing/XcodeDependencyGraphBuilderLive"),

        // Sources/Library/Parsing
        .target(name: "DumpPackageService", path: "Sources/Library/Parsing/DumpPackageService"),
        .target(name: "DumpPackageServiceLive", dependencies: [
            "DumpPackageService",
            "ShellCommandRunner"
        ], path: "Sources/Library/Parsing/DumpPackageServiceLive"),
        .target(name: "PackageSwiftFile", path: "Sources/Library/Parsing/PackageSwiftFile"),
        .target(name: "PackageSwiftFileParser", dependencies: [
            "PackageSwiftFile"
        ], path: "Sources/Library/Parsing/PackageSwiftFileParser"),
        .target(name: "PackageSwiftFileParserLive", dependencies: [
            "DumpPackageService",
            "PackageSwiftFile",
            "PackageSwiftFileParser"
        ], path: "Sources/Library/Parsing/PackageSwiftFileParserLive"),
        .target(name: "ProjectRootClassifier", path: "Sources/Library/Parsing/ProjectRootClassifier"),
        .target(name: "ProjectRootClassifierLive", dependencies: [
            "FileSystem",
            "ProjectRootClassifier"
        ], path: "Sources/Library/Parsing/ProjectRootClassifierLive"),
        .target(name: "XcodeProject", path: "Sources/Library/Parsing/XcodeProject"),
        .target(name: "XcodeProjectParser", dependencies: [
            "XcodeProject"
        ], path: "Sources/Library/Parsing/XcodeProjectParser"),
        .target(name: "XcodeProjectParserLive", dependencies: [
            "FileSystem",
            .product(name: "XcodeProj", package: "XcodeProj"),
            "XcodeProject",
            "XcodeProjectParser"
        ], path: "Sources/Library/Parsing/XcodeProjectParserLive"),

        // Sources/Library/Utilities
        .target(name: "FileSystem", path: "Sources/Library/Utilities/FileSystem"),
        .target(name: "FileSystemLive", dependencies: [
            "FileSystem"
        ], path: "Sources/Library/Utilities/FileSystemLive"),
        .target(name: "ShellCommandRunner", path: "Sources/Library/Utilities/ShellCommandRunner"),
        .target(name: "ShellCommandRunnerLive", dependencies: [
            "ShellCommandRunner"
        ], path: "Sources/Library/Utilities/ShellCommandRunnerLive"),

        // Tests
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
            "FileSystem",
            "XcodeProject",
            "XcodeProjectParserLive"
        ], resources: [.copy("Example")])
    ]
)
