import ArgumentParser
import Foundation

@main
struct GraphDeps: ParsableCommand {
    @Argument(help: "The Xcode project to parse.")
    var input: String

    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to graph package dependencies"
    )

    func run() throws {}
}
