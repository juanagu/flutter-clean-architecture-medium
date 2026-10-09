# ADR 0001: Feature classes as composition roots

## Status

Accepted, 2026-10-09.

## Context

The app is organised by feature (`lib/src/features/<name>/`). Each feature has its own repository, use case, cubit and widgets, and some features embed or link to others (home embeds the feed, the feed embeds a like button per row, sign-in links to sign-up). Something has to build each feature's object graph and connect features without letting them reach into each other's internals.

The global `Injector` (a `get_it` wrapper) already exists for app-wide services. Registering every repository, use case and cubit there would work, but it spreads a feature's wiring across the feature and `ioc/`, and makes it easy for one feature to resolve another feature's internals by type.

## Decision

Each feature has one class, `<Name>Feature` in `<name>_feature.dart`, that is its composition root. It:

- Resolves only app-wide services (`Logger`, `FeatureConfig`, `AuthClient`, `DataRemoteClient`, `UserSessionRepository`, `RelativeTimeFormatter`) from `Injector.instance`.
- Builds the feature's own repository, use case and cubit in private `_provide*` methods.
- Exposes only `static const route`, `static generateRoutes()`, `static navigate(context)` and the `build*()` methods that return widgets.

Nothing feature-specific is registered in the `Injector`. Cross-feature links are callbacks or widgets passed in from the Feature class: `SignInFeature` hands `SignUpFeature().buildButton()` to its component; `TweetFeedFeature` hands `TweetLikeFeature().build` to the feed; `AuthIndexFeature` hands `HomeFeature.navigate` and `SignInFeature.navigate` to the entry page.

`Application` registers routes by spreading each feature's `generateRoutes()`.

## Alternatives considered

- **Register everything in `get_it`.** Less code per feature, but wiring leaves the feature folder, and any class can resolve any other feature's repository. Rejected.
- **A package per feature.** Enforces boundaries with the compiler. Too heavy for a sample app; the Feature class gives most of the benefit with no build changes.
- **Widgets resolve their own dependencies from the injector.** Hides dependencies inside the widget tree and makes widget tests need a configured injector. Rejected; widgets take `createCubit` callbacks instead.

## Consequences

- A feature's dependencies are readable in one file.
- Widget and cubit tests build objects by hand with fakes; no injector setup.
- The `Injector` interface is wider than any single feature needs (it is the app's service locator, not a feature port). Accepted for a sample.
- Boundary violations are not compiler-enforced. Review checks imports: a feature may import another feature's `<name>_feature.dart` only.
