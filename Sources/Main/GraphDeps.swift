import ArgumentParser
import Foundation

@main
struct GraphDeps: ParsableCommand {
    @Argument(help: "The input to show dependencies for. Can be en .xcodeproj file or a Package.swift file.")
    var input: String

    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to graph package dependencies"
    )

    func run() throws {
        try CompositionRoot.graphCommand.run(withInput: input)
    }
}
