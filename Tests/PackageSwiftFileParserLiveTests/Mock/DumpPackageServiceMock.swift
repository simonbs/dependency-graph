import DumpPackageService
import Foundation

struct DumpPackageServiceMock: DumpPackageService {
    private let fileURLMap: [URL: URL]

    init(fileURLMap: [URL: URL] = [:]) {
        self.fileURLMap = fileURLMap
    }

    func dumpPackageForSwiftPackageFile(at fileURL: URL) throws -> Data {
        let mappedFileURL = fileURLMap[fileURL] ?? fileURL
        return try Data(contentsOf: mappedFileURL)
    }
}
