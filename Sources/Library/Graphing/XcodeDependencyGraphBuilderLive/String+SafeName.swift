import Foundation

extension String {
    var safeName: String {
        return components(separatedBy: .alphanumerics.inverted).joined()
    }
}
