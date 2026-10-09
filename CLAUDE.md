# Twitter App (Flutter sample): project instructions

Companion repo of a Medium article on Clean Architecture, feature modules and feature toggles in Flutter. The global standards (`~/.claude/CLAUDE.md`) apply in full, and the `flutter-architecture` skill describes this repo's architecture: invoke it before writing, planning or reviewing any code here. This file only says where this repo keeps its own knowledge. Keep it short: it loads every session.

## Read first

- `docs/architecture.md`: the layers and the dependency rule, ports and adapters, the Feature class as composition root, `Either` + sealed failures, toggles, i18n, the design system and page shell, testing per layer.
- `CONTRIBUTING.md`: branch flow, the checks, where each kind of knowledge lives, and the rules that fail a review.
- `docs/development.md`: run recipes (in-memory and Firebase), Firebase setup, verifying in a browser, what bites.
- `docs/design/ux-pass-1.md` and `ux-pass-1-artboard.html`: the visual source of truth. A new or changed screen gets a frame there, approved by the owner, before it is built.
- `docs/adr/`: decisions with their alternatives. Read the ones covering what you are about to touch.
- Every feature folder has a `feature_readme.md`. Read it before touching that feature. A new feature follows the eight steps in `README.md` and ships its own readme.

## Run and check

- `flutter run -d chrome --dart-define=IN_MEMORY_BACKEND=true` runs the whole UI with no Firebase project (`demo@example.com` / `password`). The define is compile-time: changing it needs a full restart.
- Before reporting work done, run and report: `dart format --set-exit-if-changed lib test`, `flutter analyze --fatal-infos`, `flutter test`, `flutter build web --release --dart-define=IN_MEMORY_BACKEND=true`. CI runs the same four on every PR.
- UI changes ship with screenshots at 390 and desktop from the in-memory build; `docs/development.md` has the recipe.

## Contracts that must not regress

- The `tweets` document schema has one home, `lib/src/core/data/tweet_document.dart`. Likes are the `likedBy` set of user ids; the count and `likeIt` derive from it and are written with atomic set operations, never as a number.
- Remote Config keys live in `lib/src/application/feature_flags.dart` and match the parameters in the Firebase project; renaming one here means renaming it there.
- Only `integrations/` and `main.dart` import Firebase packages; only `ioc/` and `main.dart` import `integrations/`. Features import `abstractions`, `core` and `application` only, and reach other features through their Feature class alone. `test/architecture/dependency_rule_test.dart` enforces this and names the offending import; fix the import, never the test.
- Both dictionaries under `assets/i18n/` keep identical key sets, every key used in `lib/` exists, and every key is used. The i18n test fails otherwise.
- `google-services.json`, `GoogleService-Info.plist` and `lib/firebase_options.dart` stay out of git, and are never embedded in a script.
