# xcstringslint

Setup deterministic validation of your app's `.xcstrings` [string catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog).

Ensure your string catalog changes are always up-to-snuff with your team's localization requirements.

## Usage

### CLI

Using a [config file](.xcstringslint.yaml)

```bash
swift run xcstringslint --config .xcstringslint.yaml \
    Sources/StringCatalogValidator/Resources/Localizable.xcstrings
```

Using command line arguments

```bash
swift run xcstringslint \
    --require-extraction-state automatic \
    --require-locale en fr \
    --require-localization-state translated \
    Sources/StringCatalogValidator/Resources/Localizable.xcstrings
```

### GitHub Actions

See [this repository's actions for an example](.github/workflows/lint.yaml)