# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Design system in `lib/src/application/theme/`: explicit light and dark colour schemes (warm off-white surface, near-black primary, coral reserved for the liked heart), a type scale on the platform font, component themes, and `Space` / `Radii` tokens. Spec and artboard in `docs/design/ux-pass-1.md`.
- Auth forms: heading in the body (`Welcome back` / `Create your account`), show/hide password toggle, password helper on sign-up, and an inline error block (`FormErrorMessage`) for wrong credentials, email in use and weak password; unexpected errors stay snackbars.
- Compose: `X` to leave, `Tweet` pill in the app bar disabled until there is text and showing a spinner while posting, borderless field, remaining-characters counter that turns red at 20 left.
- Feed row: initial-letter avatar, `email · time` header, hairline dividers edge to edge, 44x44 like target with the count hidden at 0, hover tint on web.
- `PageContainer` caps the content at a centred column (400 for forms, 600 for the feed and composer) and aligns the app bar row and the FAB to it on wide viewports.
- Six i18n keys: `sign_in_feature.title`, `sign_up_feature.button_prompt`, `sign_up_feature.password_helper`, `form.show_password`, `form.hide_password`, `tweet_creation_feature.counter_semantics`.
- Widget tests for the inline error, the password toggle, the compose pill and counter, the feed row, the like count and the capped column.

- In-memory backend (`--dart-define=IN_MEMORY_BACKEND=true`): `InMemoryAuthClient`, `InMemoryDataRemoteClient` and `InMemorySeed` (account `demo@example.com` / `password`, three tweets). Runs the whole UI with no Firebase project.
- `DeveloperLogLogger` and `DefaultsFeatureConfig` for in-memory runs.
- `RemoteDocument` on the `DataRemoteClient` port, so repositories get the document id; `updateSet` for atomic set writes.
- Likes are stored as a `likedBy` set of user ids; the count and the heart state derive from it, so they survive scrolling and restarts and concurrent likes cannot overwrite each other.
- `FeatureGate` widget and `showTranslatedSnackBar` helper shared by features.
- `TweetLikeUnauthenticated` failure; the like cubit adopts newer tweets from the feed (`sync`).
- Relative time strings follow the UI locale (`RelativeTimeFormatter.format(..., languageCode:)`).
- `TweetDocument` in `core/data/`: one home for the Firestore field names of a tweet.
- `TweetDraft` entity in `tweet_creation`; `AuthoredTweetCreationUseCase` stamps the signed-in user and the clock.
- `AuthClientUserSessionRepository` in `core/`, shared by features that need the current user.
- Feed states `Empty` and `UnexpectedError` with a retry action; `MessageView` for empty and error states.
- `AuthIndexUnexpectedError` state with retry on the entry screen.
- `BoundedTweetFeedSorter` wrapping `InsertionTweetFeedSorter`; limit 500.
- `EmailPasswordForm` shared by sign-in and sign-up, with `EmailPasswordValidator`. Forms and the tweet composer stay mounted while submitting, so a failed attempt keeps what was typed.
- Spanish dictionary with real translations; en/es parity and key-usage tests.
- Uncaught Flutter and platform errors forwarded to the `Logger` from `main.dart`.
- Tests: entities, validators, i18n, sorters, cubits, use case, repositories, in-memory client, widget tests at 390x844.
- GitHub Actions CI: format, analyze, test, web build with the in-memory backend. Docs-only changes skipped.
- `pubspec.lock` is now committed.
- Docs: README, `docs/development.md`, `docs/architecture.md`, ADRs 0001 to 0005, a `feature_readme.md` per feature, `CONTRIBUTING.md`, this changelog.

### Changed

- Copy in both languages per the design spec (`Try again`, `Enter your email`, `Create an account`, `New tweet`, ...). Keys unchanged.
- `MessageView`: 40 icon in `onSurfaceVariant`, `bodyLarge` message, max width 320; `MaintenanceView` reuses it. Entry and feed errors use `cloud_off_outlined`; the entry's transitional states show the spinner instead of a check or block icon.
- FAB icon is `edit_outlined`; `HomeFeature` reads the compose toggle once and both renders the FAB and pads the feed (88 with it, 16 without, plus the bottom safe-area inset).
- Toolchain pinned to Flutter 3.47.7 stable / Dart 3.13 (`.fvmrc`, `pubspec.yaml`).
- States and failures are Dart 3 `sealed class` hierarchies matched with `switch`, instead of `freezed` unions.
- Lint is `flutter_lints` plus a few extra rules, with `strict-casts`, `strict-inference` and `strict-raw-types`.
- `FirebaseAuthClient` maps Firebase error codes to a vendor-neutral `AuthErrorCode`; repositories no longer see Firebase types.
- `FirebaseRemoteFeatureConfig`: 10 s fetch timeout, 1 min minimum fetch interval, falls back to defaults on a failed fetch, and forgets a failed setup so a retry can succeed. `FirebaseCrashlyticsLogger` does the same.
- A web run without the in-memory backend fails fast in `IocManager.register()` with instructions, instead of crashing inside `Firebase.initializeApp`.
- Uncaught-error forwarding is guarded: a logger that throws prints instead of re-entering the error handler.
- Crashlytics collection is disabled in debug builds.
- Android: `minSdk` 23; Google Services 4.4.3 and Crashlytics 3.0.5 Gradle plugins declared in `settings.gradle.kts`.
- Typos in file and class names fixed: `failues`, `implementaions`, `get_it_injetor`, `MaintenceView`, `signInWiget`, `TweeLikeCubit`.

### Fixed

- Tweet id was never read from the document id, so likes could not target a document.
- The like button did nothing.
- The error snackbar on tweet creation threw: there was no `Scaffold` above the listener context.
- The feed sorter dropped two tweets past the 500 limit.
- The feed stayed on a spinner when empty and never showed errors.
- Stream subscriptions were never cancelled; `TweetFeedCubit` now cancels on `close()` and cannot leak one when `subscribe()` is called twice.
- The web logger logged the method name instead of the message.
- 15 of 29 translation keys were missing and `es.json` was English.
- The email regex rejected hyphenated domains.
- A feature-config failure left the entry screen on a spinner forever.
- Uncaught Flutter errors were not forwarded to the logger.

### Removed

- `run.sh`, which embedded the Firebase config files as base64.
- `freezed`, `freezed_annotation` and `build_runner`; no code generation remains.
- `flutter_icons`.
- The mock like repository and `TweetLikeResult`.
- The duplicate `Tweet` entity in `tweet_creation` (now `TweetDraft`).
- The hand-picked lint list.
- The `**.freezed.dart` and `pubspec.lock` gitignore entries.
