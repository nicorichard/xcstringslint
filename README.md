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

## Example

`swift run xcstringslint Sources/StringCatalogValidator/Resources/Localizable.xcstrings --require-locale en fr`

```
Validation failed for key: `found state `%@`, expected %@`
  - missing translation for 1 locale: fr
Validation failed for key: `found state `%@`, expected one of %@`
  - missing translation for 1 locale: fr
Validation failed for key: `missing translation for %lld locale: %@`
  - missing translation for 1 locale: fr
Validation failed for key: `should not have extraction state `%@``
  - missing translation for 1 locale: fr
Validation failed for key: `should not have state %@`
  - missing translation for 1 locale: fr
Validation failed for key: `should not have state `%@``
  - missing translation for 1 locale: fr

[Error]: Found 6 validation issues in catalog: Sources/StringCatalogValidator/Resources/Localizable.xcstrings
```
