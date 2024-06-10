protocol Printer {
    func callAsFunction(_ message: String)
}

struct Print: Printer {
    func callAsFunction(_ message: String) {
        print(message)
    }
}
