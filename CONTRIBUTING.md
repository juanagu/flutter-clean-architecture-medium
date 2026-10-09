# Contributing

## Branch and PR flow

1. Branch off `master` with a short-lived branch (`fix/...`, `feat/...`, `docs/...`).
2. Commit with Conventional Commit messages (`fix: ...`, `feat: ...`, `docs: ...`).
3. Open a PR against `master`. CI runs format, analyze, test and the web build. Docs-only changes do not trigger it.
4. Merge when CI is green: squash merge, delete the branch.

No direct commits to `master`.

## Checks to run before pushing

```sh
dart format --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
```

Optional, to be sure the Firebase-free entry point still compiles:

```sh
flutter build web --dart-define=IN_MEMORY_BACKEND=true
```

## Where knowledge lives

| Kind | Home |
| --- | --- |
| What the project is, how to try it, how to add a feature | `README.md` |
| How to run it, Firebase setup, checks, what bites | `docs/development.md` |
| Layers, ports, conventions, diagrams | `docs/architecture.md` |
| A decision and the alternatives considered | `docs/adr/NNNN-*.md`, listed in `docs/adr/README.md` |
| What a feature exposes and its data flow | `lib/src/features/<name>/feature_readme.md` |
| What changed between versions | `CHANGELOG.md` |
| Where a coding agent starts, the checks, the contracts that must not regress | `CLAUDE.md` (`AGENTS.md` points at it); the architecture itself is the `flutter-architecture` skill in the global setup |
| The dependency rule, enforced | `test/architecture/dependency_rule_test.dart` |

Update the doc that would otherwise mislead. Do not append history to a living doc; git holds the history. ADRs get a short dated amendment instead of a rewrite.

## Rules

- **i18n:** add every new key to both `assets/i18n/en.json` and `assets/i18n/es.json`, and remove keys nothing uses. `flutter test` fails otherwise.
- **No Firebase config in git:** `google-services.json`, `GoogleService-Info.plist` and `lib/firebase_options.dart` are gitignored. Keep them that way. Never embed them in a script.
- **Dependency rule:** features import `abstractions`, `core` and `application` only. Only `ioc/` and `main.dart` import `integrations`. Only `integrations/` and `main.dart` import Firebase packages. `test/architecture/dependency_rule_test.dart` checks every import under `lib/` and fails with the offending lines; `flutter test` runs it.
- **Cross-feature access** goes through the Feature class (`route`, `navigate`, `build*`), passed as callbacks or widgets. Never import another feature's `data/`, `domain/` or `presentation/`.
- **New feature:** follow the 8 steps in `README.md` and add a `feature_readme.md`.
- **Lint:** no `// ignore` comments to get past the analyzer. Fix the code.
