import Foundation

extension URL {
    enum Mock {
        enum Example {
            static var packageA: URL {
                return NSURL.fileURL(withPath: "/Users/simon/Developer/Example/PackageA/Package.swift")
            }

            static var packageB: URL {
                return NSURL.fileURL(withPath: "/Users/simon/Developer/Example/PackageB/Package.swift")
            }

            static var packageC: URL {
                return NSURL.fileURL(withPath: "/Users/simon/Developer/Example/PackageC/Package.swift")
            }
        }

        enum DependencySyntax {
            static var byNameWithPlatformNames: URL {
                return NSURL.fileURL(withPath: "/Users/simon/Developer/DependencySyntax/ByNamePlatformNames/Package.swift")
            }

            static var target: URL {
                return NSURL.fileURL(withPath: "/Users/simon/Developer/DependencySyntax/Target/Package.swift")
            }
        }
    }
}
