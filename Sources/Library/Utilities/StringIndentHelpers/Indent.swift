import Foundation

public extension Array where Element == String {
    var indented: [String] {
        return indented(by: 1)
    }

    func indented(by indentation: Int) -> [String] {
        return map { $0.indented(by: indentation) }
    }
}

public extension String {
    var indented: String {
        return indented(by: 1)
    }

    func indented(by indentation: Int) -> String {
        let indentString = String(repeating: "  ", count: indentation)
        return split(separator: "\n", omittingEmptySubsequences: false).map { lineString in
            if lineString.trimmingCharacters(in: .whitespaces).isEmpty {
                return ""
            } else {
                return indentString + lineString
            }
        }.joined(separator: "\n")
    }
}
