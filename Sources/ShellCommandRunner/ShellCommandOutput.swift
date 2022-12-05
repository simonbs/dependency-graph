public struct ShellCommandOutput {
    public let status: Int32
    public let message: String

    public init(status: Int32, message: String) {
        self.status = status
        self.message = message
    }
}
