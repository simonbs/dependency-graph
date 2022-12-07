// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExamplePackageB",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "ExampleLibraryB", targets: ["ExampleLibraryB"])
    ],
    dependencies: [
        .package(path: "../ExamplePackageC"),
        .package(url: "git@github.com:simonbs/KeyboardToolbar.git", from: "0.1.1")
    ],
    targets: [
        .target(name: "ExampleLibraryB", dependencies: [
            .product(name: "ExampleLibraryC", package: "ExamplePackageC"),
            .product(name: "KeyboardToolbar", package: "KeyboardToolbar")
        ])
    ]
)
