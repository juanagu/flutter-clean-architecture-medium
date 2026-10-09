# ADR 0004: Custom JSON i18n loader

## Status

Accepted, 2026-10-09.

## Context

The app ships English and Spanish copy. Flutter's standard route is `flutter_localizations` plus `gen-l10n`, which generates a typed `AppLocalizations` class from ARB files at build time. This project has just removed every other code generation step, and the article wants the i18n mechanism to be readable in one small file.

## Decision

- Copy lives in `assets/i18n/en.json` and `assets/i18n/es.json`, nested by feature (`sign_in_feature.email_label`).
- `I18n` loads the JSON for the locale's language code from the asset bundle, falling back to `en.json` when the file is missing. `translate(key)` walks the dotted key and returns the string, or the key itself when it is missing or points at a branch.
- `AppLocalizationsDelegate` plugs `I18n` into `MaterialApp`; `supportedLocales` is derived from `I18n.languages`.
- Validators and cubits return keys, never strings. Widgets translate at render time with `I18n.of(context)`.
- A test enforces the dictionaries: every language has the same keys, every key used in `lib/` exists, and every dictionary key is used somewhere.

## Alternatives considered

- **`gen-l10n` with ARB files.** Typed accessors and plural/gender support, but a generation step and generated files. Rejected for this sample; it is the right choice for a product app.
- **`easy_localization` or similar packages.** Similar runtime JSON loading with more features. A dependency for something that is 60 lines here. Rejected.
- **Return the English string for a missing key.** Hides gaps. Returning the key makes a missing translation show up as `sign_in_feature.foo` in the UI and fail in tests.

## Consequences

- Keys are strings, so a typo compiles. The usage scan in `i18n_test.dart` catches it in `flutter test`.
- No plurals, genders or interpolation. The app's copy does not need them.
- Adding a language is one JSON file and one entry in `I18n.languages`. The parity test then demands every key.
- Relative time strings come from `timeago`, which has its own locale handling; it is fixed to `en` for now (known gap).
