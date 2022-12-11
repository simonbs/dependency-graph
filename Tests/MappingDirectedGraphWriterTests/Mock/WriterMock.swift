import Writer

final class WriterMock: Writer {
    private(set) var writtenValue: String?

    func write(_ input: String) throws {
        writtenValue = input
    }
}
