public protocol Writer {
    associatedtype Input
    func write(_ input: Input) throws
}
