import DumpPackageService
import Foundation

struct DumpPackageServiceMock: DumpPackageService {
    private let fileURLMap: [URL: URL] = [
        URL.Mock.examplePackageA: Bundle.module.url(forMockDumpPackageNamed: "example-package-a"),
        URL.Mock.examplePackageB: Bundle.module.url(forMockDumpPackageNamed: "example-package-b"),
        URL.Mock.examplePackageC: Bundle.module.url(forMockDumpPackageNamed: "example-package-c")
    ]

    func dumpPackageForSwiftPackageFile(at fileURL: URL) throws -> Data {
        let mappedFileURL = fileURLMap[fileURL] ?? fileURL
        return try Data(contentsOf: mappedFileURL)
    }
}

private extension Bundle {
    func url(forMockDumpPackageNamed filename: String) -> URL {
        return url(forResource: "MockData/" + filename, withExtension: "json")!
    }
}
