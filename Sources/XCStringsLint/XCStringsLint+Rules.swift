import ArgumentParser

extension XCStringsLint {
    struct Rules: ParsableCommand {
        static var configuration = CommandConfiguration(commandName: "rules")

        mutating func run() throws {
            registry.forEach {
                print($0.name)
            }
        }
    }
}
