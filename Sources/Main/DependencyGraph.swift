import ArgumentParser
import Foundation
import GraphCommand

@main
struct DependencyGraph: ParsableCommand {
    @Argument(help: "The input to show dependencies for. Can be en .xcodeproj file or a Package.swift file.")
    var input: String

    @Option(name: [.short, .long], help: """
The syntax of the output.

Valid values are:

- dot: DOT document to be passed to GraphViz. More info: https://graphviz.org/doc/info/command.html

- mermaid: Mermaid.js' diagram syntax. To be be passed to the Mermaid CLI. More info: https://github.com/mermaid-js/mermaid-cli.


""")
    var syntax: Syntax = .dot

    // swiftlint:disable:next line_length
    @Option(name: .long, help: "Specifies the spacing between adjacement nodes in the same rank. Supported by the DOT and Mermaid.js syntaxes. Translates to the nodesep option in DOT and the nodeSpacing option in Mermaid.js.")
    var nodeSpacing: Float?

    // swiftlint:disable:next line_length
    @Option(name: .long, help: "Specifies the spacing between nodes in different ranks. Supported by the DOT and Mermaid.js syntaxes. Translates to the ranksep option in DOT and the rankSpacing option in Mermaid.js.")
    var rankSpacing: Float?

    static let configuration = CommandConfiguration(
        abstract: "Generates graphs of the dependencies in an Xcode project or Swift package.",
        version: "1.0.0"
    )

    func run() throws {
        let command = CompositionRoot.graphCommand(nodeSpacing: nodeSpacing, rankSpacing: rankSpacing)
        try command.run(withInput: input, syntax: syntax)
    }
}

extension Syntax: ExpressibleByArgument {}
