import Parsing
import Foundation
import ArgumentParser
import TabularData

@main
struct DependancyOwnersCommand: ParsableCommand {
    @Argument(help: "Path to Package.swift file")
    var packageFilePath: String
    
    mutating func run() throws {
        let packageContents = try String(contentsOfFile: packageFilePath)


        struct Dependency {
            let url: URL?
            let version: String
            let owner: String
        }

        // .package(url: "https://github.com/pointfreeco/swift-parsing", exact: "0.13.0", owner: "Martin"),
        let dependencyLine = Parse(Dependency.init) {
            Skip {
                ".package(url:"
                Whitespace.init()
                "\""
            }
            Prefix(while: { $0 != "\""}).map(String.init).map(URL.init(string:))
            Skip {
                "\", exact: \""
            }
            Prefix(while: { $0 != "\""}).map(String.init)
            Skip {
                "\", owner: \""
            }
            Prefix(while: { $0 != "\""}).map(String.init)
            Skip {
                "\")"
                Optionally { "," }
            }
        }

        let file = Parse {
            Skip {
                PrefixUpTo(".package")
            }
            Many {
                dependencyLine
            } separator: {
                OneOf {
                    "\n"
                    ",\n"
                }
                PrefixUpTo(".package")
            } terminator: {
                Whitespace()
              "]"
            }
        }

        var input = packageContents[...]
        let parsed: [Dependency] = try file.parse(&input)

        let dataFrame = DataFrame(columns: [
            Column(name: "Package", contents: parsed.map { $0.url!.lastPathComponent }),
            Column(name: "Version", contents: parsed.map(\.version)),
            Column(name: "Owner", contents: parsed.map(\.owner)),
        ].map({ $0.eraseToAnyColumn() }))
        print(dataFrame)
    }
}


