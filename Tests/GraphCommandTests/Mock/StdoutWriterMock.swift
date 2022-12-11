import StdoutWriter

final class StdoutWriterMock: StdoutWriter {
    private(set) var didWrite = false

    func write(_ string: String) {
        didWrite = true
    }
}
