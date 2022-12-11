import ArgumentParser
import Foundation
import GraphCommand

@main
struct GraphDeps: ParsableCommand {
    @Argument(help: "The input to show dependencies for. Can be en .xcodeproj file or a Package.swift file.")
    var input: String

    @Option(name: [.short, .long], help: """
The syntax of the output.

Valid values are:

- dot: DOT document to be passed to GraphViz. More info: https://graphviz.org/doc/info/command.html

- mermaid: Mermaid.js' diagram syntax. To be be passed to the Mermaid CLI. More info: https://github.com/mermaid-js/mermaid-cli.


""")
    var syntax: Syntax = .dot

    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to graph package dependencies"
    )

    func run() throws {
        try CompositionRoot.graphCommand.run(withInput: input, syntax: syntax)
    }
}

extension Syntax: ExpressibleByArgument {}
