import DumpPackageService
import Foundation

struct DumpPackageServiceMock: DumpPackageService {
    private let fileURLMap: [URL: URL] = [
        URL.Mock.Example.packageA: Bundle.module.url(forMockDataNamed: "example-package-a"),
        URL.Mock.Example.packageB: Bundle.module.url(forMockDataNamed: "example-package-b"),
        URL.Mock.Example.packageC: Bundle.module.url(forMockDataNamed: "example-package-c"),
        URL.Mock.DependencySyntax.byNameWithPlatformNames: Bundle.module.url(forMockDataNamed: "dependency-syntax-byname-with-platform-names"),
        URL.Mock.DependencySyntax.target: Bundle.module.url(forMockDataNamed: "dependency-syntax-target")
    ]

    func dumpPackageForSwiftPackageFile(at fileURL: URL) throws -> Data {
        let mappedFileURL = fileURLMap[fileURL] ?? fileURL
        return try Data(contentsOf: mappedFileURL)
    }
}

private extension Bundle {
    func url(forMockDataNamed filename: String) -> URL {
        return url(forResource: "MockData/" + filename, withExtension: "json")!
    }
}
