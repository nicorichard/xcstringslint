struct PrintPrinter: Printer {
    func callAsFunction(_ message: String) {
        print(message)
    }
}
