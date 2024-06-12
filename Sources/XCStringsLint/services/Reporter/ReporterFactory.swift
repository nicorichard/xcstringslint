import ArgumentParser

enum ReporterFactory: String, ExpressibleByArgument {
    case xcode
    case cli

    func build(path: String) -> Reporter {
        switch self {
            case .xcode:
                return XcodeReporter(path: path)
            case .cli:
                return CommandLineReporter(path: path)
        }
    }
}
