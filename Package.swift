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
            "DirectedGraphTransformer",
            "DOTGraphTransformer",
            "DumpPackageService",
            "DumpPackageServiceLive",
            "FileSystem",
            "FileSystemLive",
            "GraphCommand",
            "MermaidGraphTransformer",
            "PackageDependencyGraphBuilder",
            "PackageDependencyGraphBuilderLive",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserLive",
            "ProjectRootClassifier",
            "ProjectRootClassifierLive",
            "ShellCommandRunner",
            "ShellCommandRunnerLive",
            "XcodeProjectDependencyGraphBuilder",
            "XcodeProjectDependencyGraphBuilderLive",
            "XcodeProjectParser",
            "XcodeProjectParserLive"
        ]),

        // Sources/Library/Commands
        .target(name: "GraphCommand", dependencies: [
            "DirectedGraphTransformer",
            "PackageDependencyGraphBuilder",
            "PackageSwiftFileParser",
            "ProjectRootClassifier",
            "XcodeProjectParser",
            "XcodeProjectDependencyGraphBuilder"
        ], path: "Sources/Library/Commands/GraphCommand"),

        // Sources/Library/Graphing
        .target(name: "DirectedGraph", path: "Sources/Library/Graphing/DirectedGraph"),
        .target(name: "DirectedGraphXcodeHelpers", dependencies: [
            "DirectedGraph"
        ], path: "Sources/Library/Graphing/DirectedGraphXcodeHelpers"),
        .target(name: "DirectedGraphTransformer", dependencies: [
            "DirectedGraph"
        ], path: "Sources/Library/Graphing/DirectedGraphTransformer"),
        .target(name: "DOTGraphTransformer", dependencies: [
            "DirectedGraph",
            "DirectedGraphTransformer",
            "StringIndentHelpers"
        ], path: "Sources/Library/Graphing/DOTGraphTransformer"),
        .target(name: "MermaidGraphTransformer", dependencies: [
            "DirectedGraph",
            "DirectedGraphTransformer",
            "StringIndentHelpers"
        ], path: "Sources/Library/Graphing/MermaidGraphTransformer"),
        .target(name: "PackageDependencyGraphBuilder", dependencies: [
            "DirectedGraph",
            "PackageSwiftFile"
        ], path: "Sources/Library/Graphing/PackageDependencyGraphBuilder"),
        .target(name: "PackageDependencyGraphBuilderLive", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageDependencyGraphBuilder",
            "PackageSwiftFile"
        ], path: "Sources/Library/Graphing/PackageDependencyGraphBuilderLive"),
        .target(name: "XcodeProjectDependencyGraphBuilder", dependencies: [
            "DirectedGraph",
            "PackageDependencyGraphBuilder",
            "XcodeProject"
        ], path: "Sources/Library/Graphing/XcodeProjectDependencyGraphBuilder"),
        .target(name: "XcodeProjectDependencyGraphBuilderLive", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageDependencyGraphBuilder",
            "PackageSwiftFile",
            "PackageSwiftFileParser",
            "XcodeProjectDependencyGraphBuilder",
            "XcodeProject"
        ], path: "Sources/Library/Graphing/XcodeProjectDependencyGraphBuilderLive"),

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
        .target(name: "StringIndentHelpers", path: "Sources/Library/Utilities/StringIndentHelpers"),

        // Tests
        .testTarget(name: "DirectedGraphXcodeHelpersTests", dependencies: [
            "DirectedGraphXcodeHelpers"
        ]),
        .testTarget(name: "DOTGraphTransformerTests", dependencies: [
            "DirectedGraph",
            "DOTGraphTransformer"
        ]),
        .testTarget(name: "DumpPackageServiceLiveTests", dependencies: [
            "DumpPackageServiceLive",
            "ShellCommandRunner"
        ]),
        .testTarget(name: "MermaidGraphTransformerTests", dependencies: [
            "DirectedGraph",
            "MermaidGraphTransformer"
        ]),
        .testTarget(name: "PackageDependencyGraphBuilderLiveTests", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageDependencyGraphBuilderLive",
            "PackageSwiftFile"
        ]),
        .testTarget(name: "PackageSwiftFileParserLiveTests", dependencies: [
            "DumpPackageService",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserLive"
        ], resources: [.copy("MockData")]),
        .testTarget(name: "ProjectRootClassifierLiveTests", dependencies: [
            "FileSystem",
            "ProjectRootClassifierLive"
        ]),
        .testTarget(name: "StringIndentHelpersTests", dependencies: [
            "StringIndentHelpers"
        ]),
        .testTarget(name: "XcodeProjectDependencyGraphBuilderLiveTests", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageDependencyGraphBuilder",
            "PackageSwiftFileParser",
            "XcodeProjectDependencyGraphBuilderLive",
            "XcodeProject"
        ]),
        .testTarget(name: "XcodeProjectParserLiveTests", dependencies: [
            "FileSystem",
            "XcodeProject",
            "XcodeProjectParserLive"
        ], resources: [.copy("Example")])
    ]
)
