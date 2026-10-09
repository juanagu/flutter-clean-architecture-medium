# ADR 0003: Feature toggles from Remote Config, checked at the entry widget

## Status

Accepted, 2026-10-09.

## Context

The article demonstrates feature toggles: turning the whole app, sign-up, and tweet creation on or off without a release. The toggle source must be swappable (tests and the in-memory run cannot reach Firebase) and a failing source must not break the app.

## Decision

- A `FeatureConfig` port with one method, `Future<bool> isEnabled(String key)`.
- Keys and defaults in one place, `FeatureFlags`: `appIsActive`, `signUpFeatureIsActive`, `tweetCreationIsActive`, all default `true`. The strings are the Remote Config parameter names.
- Mobile binds `FirebaseRemoteFeatureConfig`: 10 s fetch timeout, 1 min minimum fetch interval, defaults set before `fetchAndActivate()`, and a failed fetch logged and answered from the defaults. Web and in-memory bind `DefaultsFeatureConfig`.
- A flag is checked once, at the feature's entry widget, never deeper:
  - `appIsActive` in `AuthIndexCubit.check()`, before the session check. Off shows `MaintenanceView`.
  - `signUpFeatureIsActive` gates `SignUpButton` (wrapped in `FeatureGate` by `SignUpFeature.buildButton()`). Off renders nothing.
  - `tweetCreationIsActive` is read once by `HomeFeature.buildPage()` (`FeatureGate.builder`), which renders the FAB and sizes the feed padding from it. Off renders nothing.
- The routes behind a hidden button stay registered. The toggle hides the way in, it does not remove the feature.
- An exception from `FeatureConfig` on the entry screen becomes `AuthIndexUnexpectedError` with a retry, not a hung spinner.

## Alternatives considered

- **Check flags in use cases or repositories.** Puts toggle logic in business code and makes every test set up flags. Rejected.
- **Load all flags at startup into a value object.** Simpler widgets, but a fetch failure blocks startup, and Remote Config already caches. Rejected.
- **Unregister routes when a flag is off.** Requires knowing flags before `MaterialApp` builds, which means an async startup gate. Hiding the entry point is enough for the sample.

## Consequences

- A toggle is one key in `FeatureFlags`, one Remote Config parameter, and one check in one widget.
- `FeatureGate` is a `StatefulWidget` that fetches once in `initState`. A flag change shows after the screen rebuilds, not live.
- A deep link to `/sign-up` or `/tweet` still works when its toggle is off. Acceptable for a sample; a real app would guard the route too.
- Remote Config's 1 min cache means console changes take up to a minute plus a restart to appear.
