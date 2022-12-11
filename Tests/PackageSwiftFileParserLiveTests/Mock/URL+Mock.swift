import Foundation

extension URL {
    enum Mock {
        static var examplePackageA: URL {
            return NSURL.fileURL(withPath: "/Users/simon/Developer/Example/ExamplePackageA/Package.swift")
        }

        static var examplePackageB: URL {
            return NSURL.fileURL(withPath: "/Users/simon/Developer/Example/ExamplePackageB/Package.swift")
        }

        static var examplePackageC: URL {
            return NSURL.fileURL(withPath: "/Users/simon/Developer/Example/ExamplePackageC/Package.swift")
        }
    }
}
