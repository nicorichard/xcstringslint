import ArgumentParser

enum ReporterFactory: String, ExpressibleByArgument {
    case xcode
    case cli

    func build(path: String, strict: Bool) -> Reporter {
        switch self {
            case .xcode:
                return XcodeReporter(path: path, strict: strict)
            case .cli:
                return CommandLineReporter(path: path, strict: strict)
        }
    }
}
