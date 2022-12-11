import Writer

public struct StdoutWriter: Writer {
    public init() {}

    public func write(_ string: String) {
        print(string)
    }
}
