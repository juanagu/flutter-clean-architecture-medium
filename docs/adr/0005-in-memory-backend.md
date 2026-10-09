# ADR 0005: In-memory backend behind a compile-time define

## Status

Accepted, 2026-10-09.

## Context

The app needs a Firebase project to do anything: sign in, read the feed, post a tweet. Readers of the article who clone the repo would have to create a project and download two config files before seeing a screen, and CI could not build or exercise the UI at all. The previous `run.sh` worked around this by embedding the owner's Firebase config as base64, which is both a secret in git and useless to anyone else.

Every outside service already sits behind a port (`AuthClient`, `DataRemoteClient`, `FeatureConfig`, `Logger`).

## Decision

- Add in-process adapters: `InMemoryAuthClient` (accounts in a map, min password length 6) and `InMemoryDataRemoteClient` (collections of `RemoteDocument`, `watch()` emits on listen and after every change). `InMemorySeed` provides the account `demo@example.com` / `password` and three tweets.
- Select them with a compile-time define: `--dart-define=IN_MEMORY_BACKEND=true`, read by `IocManager.useInMemoryBackend` through `bool.fromEnvironment`. In that mode `IocManager` also binds `DeveloperLogLogger` and `DefaultsFeatureConfig`, and `main.dart` skips `Firebase.initializeApp()`.
- CI builds the web app with that define to prove the Firebase-free entry point compiles.
- The in-memory adapters are also the test doubles for repository tests.

## Alternatives considered

- **Firebase Emulator Suite.** Realistic, but needs the Firebase CLI, Java and a project id, which is the setup cost this decision removes. Still the right tool for integration-testing the Firebase adapters themselves.
- **A runtime switch (settings screen or environment variable).** Would ship the in-memory code path to users and need UI. A compile-time define keeps it out of release builds by default and needs no UI.
- **Separate `main_dev.dart` entry point.** Works, but duplicates `main.dart` and is easy to let drift. One `main.dart` with one `if` is smaller.

## Consequences

- `flutter run -d chrome --dart-define=IN_MEMORY_BACKEND=true` works on a fresh clone with no Firebase.
- The define is resolved at build time. Changing it needs a full restart, not a hot restart.
- Native builds still need the Firebase config files to compile, because the Firebase Gradle and CocoaPods plugins are always applied.
- The in-memory store keeps the signed-in user and all documents in process memory; everything resets on restart.
- Two adapters per port means the port contract is exercised twice, which is what keeps the ports honest.
