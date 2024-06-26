# xcstringslint

Setup deterministic validation of your app's `.xcstrings` [string catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog).

Ensure your string catalog changes are always up-to-snuff with your team's localization requirements.

## Usage

### CLI

With a [config file](.xcstringslint.yaml) located in the same directory as the executable

```bash
swift run xcstringslint Sources/StringCatalogValidator/Resources/Localizable.xcstrings
```

To specify a config file append `--config [config file path]`

### GitHub Actions

See [this repository's actions for an example](.github/workflows/lint.yaml)

## Example

```
$ swift run xcstringslint Sources/StringCatalogValidator/Resources/Localizable.xcstrings --require-locale en fr

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
