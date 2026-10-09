# Development

How to run the app, set up Firebase, and run the checks. For what the code looks like, see [architecture.md](architecture.md).

## Prerequisites

- Flutter 3.47.7 stable (Dart 3.13). The version is pinned in `.fvmrc` and `pubspec.yaml`.
- FVM is optional. With it: `fvm install` then prefix commands with `fvm`. Without it, install that version with your usual Flutter setup.
- Chrome, for the web run.
- For Android or iOS: the platform SDK and a Firebase project (below).

There is no code generation. `flutter pub get` is the only setup step.

## Run without Firebase

```sh
flutter pub get
flutter run -d chrome --dart-define=IN_MEMORY_BACKEND=true
```

`IN_MEMORY_BACKEND=true` makes `IocManager` bind the in-memory auth client and document store instead of Firebase, and `main.dart` skips `Firebase.initializeApp()`. Logs go to the Dart developer log and every feature flag takes its default (all on).

Seeded data (`lib/src/integrations/in_memory/in_memory_seed.dart`):

- Account `demo@example.com` / `password`.
- Three tweets by that account.

Sign-up works too, with a minimum password length of 6. Everything lives in the process and is lost on restart.

The same define works on a device or emulator: `flutter run --dart-define=IN_MEMORY_BACKEND=true`. The Firebase config files still have to exist for the native build to compile the Firebase plugins.

## Firebase project setup

Needed for the real backend on Android and iOS.

1. Create a Firebase project.
2. Add an Android app with package name `com.juanagu.app`. Download `google-services.json` into `android/app/`.
3. Add an iOS app with bundle id `com.juanagu.app`. Download `GoogleService-Info.plist` into `ios/Runner/`.
4. Authentication: enable the Email/Password sign-in provider.
5. Firestore: create a database. Tweets live in a `tweets` collection with these fields:

   | Field | Type |
   | --- | --- |
   | `content` | string |
   | `owner` | map `{ id: string, email: string }` |
   | `creationDate` | int, milliseconds since epoch, UTC |
   | `likedBy` | array of user ids |

   The like count is `likedBy.length`; `likeIt` is whether the signed-in user id is in the array. Rules must let signed-in users read the collection, create documents, and update only the `likedBy` field. The field names are declared once in `lib/src/core/data/tweet_document.dart`.
6. Remote Config: add three boolean parameters, `appIsActive`, `signUpFeatureIsActive` and `tweetCreationIsActive`. The app defaults all three to `true` when the fetch fails (`lib/src/application/feature_flags.dart`).
7. Crashlytics: enable it in the console. The app turns collection off in debug builds, so only release builds report.

Both config files are gitignored. Never commit them.

Android specifics: `minSdk` is 23 (required by `firebase_auth`). The Gradle plugins `com.google.gms.google-services` 4.4.3 and `com.google.firebase.crashlytics` 3.0.5 are declared in `android/settings.gradle.kts` and applied in `android/app/build.gradle.kts`.

### Web with Firebase

Not wired yet. A web run without `IN_MEMORY_BACKEND=true` stops in `IocManager.register()` with an `UnsupportedError` that says so. Wiring it would need `flutterfire configure` (which generates the gitignored `lib/firebase_options.dart`), passing `DefaultFirebaseOptions.currentPlatform` to `Firebase.initializeApp` in `main.dart`, and web-capable adapters for `Logger` and `FeatureConfig` (Crashlytics has no web support).

## Run on Android or iOS

With the Firebase files in place:

```sh
flutter run
```

Pick the device with `-d <id>` when more than one is connected. The mobile wiring uses Crashlytics for logging, Remote Config for flags, Firebase Auth and Firestore for data.

## Checks

Run all three before pushing. CI runs the same commands.

```sh
dart format --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
```

Lint is `flutter_lints` plus a few extra rules, with `strict-casts`, `strict-inference` and `strict-raw-types` on (`analysis_options.yaml`).

## Tests

`test/` mirrors `lib/`. What is covered:

- `test/core/domain/entities/tweet_test.dart`: feed ordering and like toggle on `Tweet`.
- `test/application/validators/email_validator_test.dart`: the email regex and the form validator.
- `test/application/localizations/i18n_test.dart`: `translate`, en/es key parity, every key used in `lib/` exists, every dictionary key is used.
- `test/application/widgets/forms/email_password_form_test.dart`: widget test of the shared form, in English and Spanish.
- `test/features/auth/.../auth_index_cubit_test.dart`: maintenance, authorized, unauthorized, config failure.
- `test/features/sign_in/sign_in_test.dart`: repository mapping through `InMemoryAuthClient` and the cubit.
- `test/features/sign_up/.../sign_up_remote_repository_test.dart`: taken email, weak password.
- `test/features/tweet_creation/.../authored_tweet_creation_use_case_test.dart`: user and clock stamping, no session.
- `test/features/tweet_feed/domain/sorters/tweet_feed_sorters_test.dart`: insertion sort and the bounded wrapper.
- `test/features/tweet_feed/presentation/cubits/tweet_feed_cubit_test.dart`: loading, found, empty, error, cancel on close.
- `test/features/tweet_feed/presentation/widgets/tweet_feed_component_test.dart`: widget test of the feed states with retry.
- `test/features/tweet_like/.../tweet_like_cubit_test.dart`: optimistic update, rollback, no double toggle.
- `test/integrations/in_memory/in_memory_data_remote_client_test.dart`: ordering, add, update, re-emit.

Helpers in `test/support/`:

- `fakes.dart`: `RecordingLogger`, `MapFeatureConfig`, `FixedUserSessionRepository`, `FixedRelativeTimeFormatter`, `testUser`, `makeTweet(...)`.
- `localized.dart`: `loadDictionary(languageCode)` reads the real JSON from disk; `pumpLocalized(tester, child, languageCode:, viewport:)` wraps a widget in a `MaterialApp` with that dictionary and a `Scaffold`, at 390x844 by default.

Widget tests use the shipped dictionaries, so a copy change shows up in them.

## CI

`.github/workflows/ci.yml`, one job, 15 minute timeout:

- Runs on every pull request and on every push to `master`.
- Skips when only `**.md` or `docs/**` changed.
- Steps: `flutter pub get`, format check, `flutter analyze --fatal-infos`, `flutter test`, `flutter build web --release --dart-define=IN_MEMORY_BACKEND=true`.
- A newer push cancels the older run on a PR, not on `master`.

There is no release tier; the web build is the only build CI makes, and it proves the Firebase-free entry point compiles.

## What bites

- **Crashlytics is off in debug.** `FirebaseCrashlyticsLogger` calls `setCrashlyticsCollectionEnabled(!kDebugMode)`. Test crash reporting on a release or profile build.
- **Remote Config caches for 1 minute.** `minimumFetchInterval` is 1 min and `fetchTimeout` is 10 s. After changing a flag in the console, wait a minute and restart the app. A failed fetch logs an error and falls back to the defaults.
- **`IN_MEMORY_BACKEND` is a compile-time define.** `bool.fromEnvironment` is resolved at build time. Changing the flag needs a full restart (stop and `flutter run` again), not a hot reload or hot restart.
- **The i18n test is strict.** Adding a key to only one of `en.json` / `es.json` fails the parity test. Leaving a key in the dictionaries that no file under `lib/` uses fails the unused-key test. Keys are collected by regex from `translate('...')` calls, `...Key = '...'` constants, and dotted string literals.
- **Flags are read once per gate.** `FeatureGate` (`lib/src/application/widgets/feature_gate.dart`) fetches its flag in `initState`. A changed flag shows after the screen is rebuilt.
- **Firebase files on native builds.** Without `google-services.json` the Android build fails at the Gradle step even in in-memory mode, because the Google Services plugin is always applied.

## Verified in this PR / not verified

Verified on the machine that produced this rewrite:

- `dart format`, `flutter analyze --fatal-infos` and `flutter test` pass.
- `flutter build web --dart-define=IN_MEMORY_BACKEND=true` builds. The build was served and opened in Chrome: the entry screen routed to sign-in and the form's validation messages rendered. The signed-in screens were not driven in the browser (a password-manager extension on that machine blocked the password field); they are covered by the widget tests at 390x844.

Not verified:

- The Android build. The machine has no Android SDK, so the Gradle plugin declarations and the `minSdk` change compiled nowhere. Expect to fix Gradle details on the first Android run.
- The iOS build.
- The Firebase wiring end to end (Auth, Firestore, Remote Config, Crashlytics) against a real project.
