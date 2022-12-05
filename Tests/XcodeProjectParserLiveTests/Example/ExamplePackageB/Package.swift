// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExamplePackageB",
    products: [
        .library(name: "ExampleLibrary", targets: ["ExampleLibrary"])
    ],
    targets: [
        .target(name: "ExampleLibrary")
    ]
)
