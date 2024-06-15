import StringCatalogValidator

let registry: [(Rule & ValuesConfigurable).Type] = [
    Rules.RequireExtractionState.self,
    Rules.RejectExtractionState.self,
    Rules.RequireLocale.self,
    Rules.RequireLocalizationState.self,
    Rules.RejectLocalizationState.self,
]

extension Rules.RequireExtractionState: ValuesConfigurable {
    init(values: [String]) {
        self.init(in: values)
    }
}

extension Rules.RejectExtractionState: ValuesConfigurable {
    init(values: [String]) {
        self.init(in: values)
    }
}

extension Rules.RequireLocale: ValuesConfigurable {
    init(values: [String]) {
        self.init(in: values)
    }
}

extension Rules.RequireLocalizationState: ValuesConfigurable {
    init(values: [String]) {
        self.init(in: values)
    }
}

extension Rules.RejectLocalizationState: ValuesConfigurable {
    init(values: [String]) {
        self.init(in: values)
    }
}
