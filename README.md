# xcstringslint

Setup deterministic validation of your app's `.xcstrings` [string catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog).

Ensure your string catalog changes are always up-to-snuff with your team's localization requirements.

## Usage

### Running
#### CLI

With a [config file](.xcstringslint.yaml) located in the same directory as the executable

```bash
swift run xcstringslint Sources/StringCatalogValidator/Resources/Localizable.xcstrings
```

To specify a config file append `--config [config file path]`

#### GitHub Actions

See [this repository's actions for an example](.github/workflows/lint.yaml)

#### Plugin

The [XCStringsLintPlugin](https://github.com/nicorichard/XCStringsLintPlugin) repository is maintained separately.

### Configuration

#### Rules

##### `require-locale`

Ensures that for each locale has a translation present in the `.xcstrings` file.

e.g. ensure that each key has a translation for `en` and `fr`
```yaml
rules:
    require-locale:
        values:
            - en
            - fr
```

##### `require-localization-state`

Ensures that each key has a localization state matching the provided values.

e.g. ensure that each key has a localization state of `translated`
```yaml
rules:
    require-localization-state:
        value: translated
```

To negate this rule use `reject-localization-state` instead.

##### `require-extraction-state`

Ensures that each key has a translation for each extraction state.

e.g. ensure that each key was automatically extracted
```yaml
rules:
    require-extraction-state:
        value: "automatic"
```

To negate this rule use `reject-extraction-state` instead.

#### Ignoring Keys

To ignore all validation for a particular key, either mark them as "Don't Translate" or include `[no-lint]` in the key's comment.

To ignore a specific rule, include `[no-lint:rule-name]` in the key's comment, e.g. `[no-lint:require-locale]`

## Example Output

```
$ swift run xcstringslint Sources/StringCatalogValidator/Resources/Localizable.xcstrings

`Rejects an entry if its extraction state matches any of the provided values. Known extractions states:  %@`:
  ⚠️ require-localization-state: no translation state found
  ⚠️ require-locale: missing translation for 1 locale: en
`Rejects an entry if its extraction state matchs any of the provided values. Known extractions states:  %@`:
  ⚠️ require-extraction-state: should not have extraction state `stale`
`found state `%@`, expected %@`:
  ⚠️ require-extraction-state: should not have extraction state `stale`
`found state `%@`, expected `%@``:
  ⚠️ require-localization-state: found state `new`, expected `translated`
`found state `%@`, expected one of %@`:
  ⚠️ require-extraction-state: should not have extraction state `stale`
`found state `%@`, expected one of: %@`:
  ⚠️ require-localization-state: found state `new`, expected `translated`

[Warning]: Found 7 total issues in 6 keys
```
