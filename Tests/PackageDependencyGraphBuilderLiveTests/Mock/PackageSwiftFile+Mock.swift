import PackageSwiftFile

extension PackageSwiftFile {
    static var noDependenciesMock: PackageSwiftFile {
        return PackageSwiftFile(
            name: "ExamplePackageA",
            products: [
                PackageSwiftFile.Product(name: "ExampleLibraryA", targets: ["ExampleLibraryA"])
            ],
            targets: [
                PackageSwiftFile.Target(name: "ExampleLibraryA")
            ]
        )
    }

    static var withDependenciesMock: PackageSwiftFile {
        return PackageSwiftFile(
            name: "ExamplePackageA",
            products: [
                PackageSwiftFile.Product(name: "ExampleLibraryA", targets: ["ExampleLibraryA"])
            ],
            targets: [
                PackageSwiftFile.Target(name: "ExampleLibraryA", dependencies: [
                    .product("ExampleLibraryB", inPackage: "ExamplePackageB")
                ])
            ],
            dependencies: [
                .fileSystem(
                    identity: "examplepackageb",
                    path: "/Users/simon/Developer/Example/ExamplePackageB",
                    packageSwiftFile: .examplePackageB
                )
            ]
        )
    }
}

private extension PackageSwiftFile {
    static var examplePackageB: PackageSwiftFile {
        return PackageSwiftFile(
            name: "ExamplePackageB",
            products: [
                PackageSwiftFile.Product(name: "ExampleLibraryB", targets: ["ExampleLibraryB"])
            ],
            targets: [
                PackageSwiftFile.Target(name: "ExampleLibraryB", dependencies: [
                    .name("ExampleLibraryBFoo"),
                    .product("ExampleLibraryC", inPackage: "ExamplePackageC")
                ]),
                PackageSwiftFile.Target(name: "ExampleLibraryBFoo")
            ],
            dependencies: [
                .fileSystem(
                    identity: "examplepackagec",
                    path: "/Users/simon/Developer/Example/ExamplePackageC",
                    packageSwiftFile: .examplePackageC
                )
            ]
        )
    }

    static var examplePackageC: PackageSwiftFile {
        return PackageSwiftFile(
            name: "ExamplePackageC",
            products: [
                PackageSwiftFile.Product(name: "ExampleLibraryC", targets: ["ExampleLibraryC"])
            ],
            targets: [
                PackageSwiftFile.Target(name: "ExampleLibraryC", dependencies: [
                    .name("ExampleLibraryC")
                ]),
                PackageSwiftFile.Target(name: "ExampleLibraryC")
            ]
        )
    }
}
