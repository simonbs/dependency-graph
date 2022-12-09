import Foundation

extension URL {
    enum Mock {
        static var examplePackageA: URL {
            return URL(filePath: "/Users/simon/Developer/Example/ExamplePackageA/Package.swift")
        }

        static var examplePackageB: URL {
            return URL(filePath: "/Users/simon/Developer/Example/ExamplePackageB/Package.swift")
        }
    }
}
