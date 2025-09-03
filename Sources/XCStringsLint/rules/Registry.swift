import StringCatalogValidator

let registry: [(Rule & ValuesConfigurable).Type] = [
    Rules.RequireExtractionState.self,
    Rules.RejectExtractionState.self,
    Rules.RequireLocale.self,
    Rules.RequireLocalizationState.self,
    Rules.RejectLocalizationState.self,
    Rules.RequireComment.self,
    Rules.RequireMatchingPlaceholders.self,
    Rules.RejectEmptyValues.self,
    Rules.RejectPatterns.self,
    Rules.RequirePositionalPlaceholders.self,
    Rules.RequireObjectPlaceholders.self
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

extension Rules.RequireComment: ValuesConfigurable {
    init(values: [String]) {
        self.init()
    }
}

extension Rules.RequireMatchingPlaceholders: ValuesConfigurable {
    init(values: [String]) {
        self.init()
    }
}

extension Rules.RejectEmptyValues: ValuesConfigurable {
    init(values: [String]) {
        self.init()
    }
}

extension Rules.RejectPatterns: ValuesConfigurable {
    init(values: [String]) {
        self.init(patterns: values)
    }
}

extension Rules.RequirePositionalPlaceholders: ValuesConfigurable {
    init(values: [String]) {
        let applyToAll = values.contains("all")
        self.init(applyToAll: applyToAll)
    }
}

extension Rules.RequireObjectPlaceholders: ValuesConfigurable {
    init(values: [String]) {
        self.init()
    }
}
