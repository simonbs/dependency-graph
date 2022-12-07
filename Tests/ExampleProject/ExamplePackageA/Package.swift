// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExamplePackageA",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "ExampleLibraryA", targets: ["ExampleLibraryA"])
    ],
    targets: [
        .target(name: "ExampleLibraryA")
    ]
)
