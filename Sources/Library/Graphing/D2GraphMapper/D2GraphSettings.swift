import Foundation

public struct D2GraphSettings {
    public let direction: String

    public init() {
        direction = "right"
    }
}

extension D2GraphSettings {
    var stringRepresentation: String {
        let lines = ["direction: \(direction)"]
        return lines.joined(separator: "\n")
    }
}
