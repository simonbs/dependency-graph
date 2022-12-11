import Foundation

struct DOTGraphSettings {
    let layout: String
    let rankdir: String
}

extension DOTGraphSettings {
    var stringRepresentation: String {
        return [
            "layout=\(layout)",
            "rankdir=\(rankdir)"
        ].joined(separator: "\n")
    }
}
