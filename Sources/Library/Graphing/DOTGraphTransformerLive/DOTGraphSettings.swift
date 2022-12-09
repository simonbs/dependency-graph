import Foundation

struct DOTGraphSettings {
    let layout: String
}

extension DOTGraphSettings {
    var stringRepresentation: String {
        return "layout=\(layout)"
    }
}
