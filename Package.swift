// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DependencyGraph",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "dependency-graph", targets: ["Main"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.8.0"))
    ],
    targets: [
        .executableTarget(name: "Main", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "D2GraphMapper",
            "DirectedGraphMapper",
            "DirectedGraphWriter",
            "DOTGraphMapper",
            "DumpPackageService",
            "DumpPackageServiceLive",
            "FileSystem",
            "FileSystemLive",
            "GraphCommand",
            "MappingDirectedGraphWriter",
            "MermaidGraphMapper",
            "PackageGraphBuilder",
            "PackageGraphBuilderLive",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserCache",
            "PackageSwiftFileParserCacheLive",
            "PackageSwiftFileParserLive",
            "ProjectRootClassifier",
            "ProjectRootClassifierLive",
            "ShellCommandRunner",
            "ShellCommandRunnerLive",
            "StdoutWriter",
            "XcodeProjectGraphBuilder",
            "XcodeProjectGraphBuilderLive",
            "XcodeProjectParser",
            "XcodeProjectParserLive"
        ]),

        // Sources/Library/Commands
        .target(name: "GraphCommand", dependencies: [
            "DirectedGraphMapper",
            "DirectedGraphWriter",
            "PackageGraphBuilder",
            "PackageSwiftFileParser",
            "ProjectRootClassifier",
            "XcodeProjectParser",
            "XcodeProjectGraphBuilder"
        ], path: "Sources/Library/Commands/GraphCommand"),

        // Sources/Library/Graphing
        .target(name: "D2GraphMapper", dependencies: [
            "DirectedGraph",
            "DirectedGraphMapper",
            "StringIndentHelpers"
        ], path: "Sources/Library/Graphing/D2GraphMapper"),
        .target(name: "DirectedGraph", path: "Sources/Library/Graphing/DirectedGraph"),
        .target(name: "DirectedGraphXcodeHelpers", dependencies: [
            "DirectedGraph"
        ], path: "Sources/Library/Graphing/DirectedGraphXcodeHelpers"),
        .target(name: "DirectedGraphMapper", dependencies: [
            "DirectedGraph"
        ], path: "Sources/Library/Graphing/DirectedGraphMapper"),
        .target(name: "DOTGraphMapper", dependencies: [
            "DirectedGraph",
            "DirectedGraphMapper",
            "StringIndentHelpers"
        ], path: "Sources/Library/Graphing/DOTGraphMapper"),
        .target(name: "MermaidGraphMapper", dependencies: [
            "DirectedGraph",
            "DirectedGraphMapper",
            "StringIndentHelpers"
        ], path: "Sources/Library/Graphing/MermaidGraphMapper"),
        .target(name: "PackageGraphBuilder", dependencies: [
            "DirectedGraph",
            "PackageSwiftFile"
        ], path: "Sources/Library/Graphing/PackageGraphBuilder"),
        .target(name: "PackageGraphBuilderLive", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageGraphBuilder",
            "PackageSwiftFile"
        ], path: "Sources/Library/Graphing/PackageGraphBuilderLive"),
        .target(name: "XcodeProjectGraphBuilder", dependencies: [
            "DirectedGraph",
            "PackageGraphBuilder",
            "XcodeProject"
        ], path: "Sources/Library/Graphing/XcodeProjectGraphBuilder"),
        .target(name: "XcodeProjectGraphBuilderLive", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageGraphBuilder",
            "PackageSwiftFile",
            "PackageSwiftFileParser",
            "XcodeProjectGraphBuilder",
            "XcodeProject"
        ], path: "Sources/Library/Graphing/XcodeProjectGraphBuilderLive"),

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
        .target(name: "PackageSwiftFileParserCache", dependencies: [
            "PackageSwiftFile"
        ], path: "Sources/Library/Parsing/PackageSwiftFileParserCache"),
        .target(name: "PackageSwiftFileParserCacheLive", dependencies: [
            "PackageSwiftFile",
            "PackageSwiftFileParserCache"
        ], path: "Sources/Library/Parsing/PackageSwiftFileParserCacheLive"),
        .target(name: "PackageSwiftFileParserLive", dependencies: [
            "DumpPackageService",
            "PackageSwiftFile",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserCache"
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

        // Sources/Library/Outputting
        .target(name: "DirectedGraphWriter", dependencies: [
            "DirectedGraph",
            "Writer"
        ], path: "Sources/Library/Outputting/DirectedGraphWriter"),
        .target(name: "MappingDirectedGraphWriter", dependencies: [
            "DirectedGraph",
            "DirectedGraphMapper",
            "DirectedGraphWriter"
        ], path: "Sources/Library/Outputting/MappingDirectedGraphWriter"),
        .target(name: "StdoutWriter", dependencies: [
            "Writer"
        ], path: "Sources/Library/Outputting/StdoutWriter"),
        .target(name: "Writer", path: "Sources/Library/Outputting/Writer"),

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
        .testTarget(name: "D2GraphMapperTests", dependencies: [
            "DirectedGraph",
            "D2GraphMapper"
        ]),
        .testTarget(name: "DirectedGraphTests", dependencies: [
            "DirectedGraph"
        ]),
        .testTarget(name: "DirectedGraphXcodeHelpersTests", dependencies: [
            "DirectedGraphXcodeHelpers"
        ]),
        .testTarget(name: "DOTGraphMapperTests", dependencies: [
            "DirectedGraph",
            "DOTGraphMapper"
        ]),
        .testTarget(name: "DumpPackageServiceLiveTests", dependencies: [
            "DumpPackageServiceLive",
            "ShellCommandRunner"
        ]),
        .testTarget(name: "GraphCommandTests", dependencies: [
            "GraphCommand"
        ]),
        .testTarget(name: "MappingDirectedGraphWriterTests", dependencies: [
            "MappingDirectedGraphWriter"
        ]),
        .testTarget(name: "MermaidGraphMapperTests", dependencies: [
            "DirectedGraph",
            "MermaidGraphMapper"
        ]),
        .testTarget(name: "PackageGraphBuilderLiveTests", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageGraphBuilderLive",
            "PackageSwiftFile"
        ]),
        .testTarget(name: "PackageSwiftFileParserLiveTests", dependencies: [
            "DumpPackageService",
            "PackageSwiftFileParser",
            "PackageSwiftFileParserCache",
            "PackageSwiftFileParserLive"
        ], resources: [.copy("MockData")]),
        .testTarget(name: "ProjectRootClassifierLiveTests", dependencies: [
            "FileSystem",
            "ProjectRootClassifierLive"
        ]),
        .testTarget(name: "StringIndentHelpersTests", dependencies: [
            "StringIndentHelpers"
        ]),
        .testTarget(name: "XcodeProjectGraphBuilderLiveTests", dependencies: [
            "DirectedGraph",
            "DirectedGraphXcodeHelpers",
            "PackageGraphBuilder",
            "PackageSwiftFileParser",
            "XcodeProjectGraphBuilderLive",
            "XcodeProject"
        ]),
        .testTarget(name: "XcodeProjectParserLiveTests", dependencies: [
            "FileSystem",
            "XcodeProject",
            "XcodeProjectParserLive"
        ], resources: [.copy("Example")])
    ]
)
