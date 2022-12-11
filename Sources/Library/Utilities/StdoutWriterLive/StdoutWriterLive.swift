import StdoutWriter

public struct StdoutWriterLive: StdoutWriter {
    public init() {}

    public func write(_ string: String) {
        print(string)
    }
}
