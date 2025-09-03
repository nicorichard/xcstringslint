import ArgumentParser

extension xcstringslint {
    struct Rules: ParsableCommand {
        static var configuration = CommandConfiguration(commandName: "rules")

        mutating func run() throws {
            let rules = ConfigurableRule.allCases.map(\.type)

            let alignment = rules
                .map { $0.name }
                .reduce(0, { longest, next in
                    max(longest, next.count)
            }) + 2

            print()

            rules.forEach {
                let padding = alignment - $0.name.count

                let namePad = String(repeating: " ", count: padding)
                print($0.name + namePad + $0.description)

                let configPad = String(repeating: " ", count: alignment)
                print("\(configPad)`value`, `values`")

                print()
            }
        }
    }
}
