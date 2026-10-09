# auth

## Purpose

The entry screen at `/`. Checks the `appIsActive` toggle, then whether there is a session, and routes to home or sign-in. Shows a maintenance view when the app is off and an error with retry when either check fails.

## Exposed interface

`AuthIndexFeature` (`auth_index_feature.dart`):

- `static const String route = '/'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamedAndRemoveUntil`, clears the stack.
- `Widget buildPage()`

## States and failures

- `AuthIndexState` (sealed): `AuthIndexInitial`, `AuthIndexAuthorized`, `AuthIndexUnauthorized`, `AuthIndexUnexpectedError`, `AuthIndexMaintenance`.
- `AuthSessionFailure` (sealed): `AuthSessionUnauthorized`, `AuthSessionUnexpectedError`.

## Data flow

1. `AuthIndexPage` creates `AuthIndexCubit` and calls `check()`.
2. The cubit asks `FeatureConfig.isEnabled(FeatureFlags.appIsActive)`. An exception becomes `AuthIndexUnexpectedError`; `false` becomes `AuthIndexMaintenance`.
3. Otherwise it calls `AuthSessionRepository.isAuthorized()`, backed by `AuthSessionRemoteRepository` over `AuthClient.currentUser`.
4. `Right(unit)` becomes `AuthIndexAuthorized`; the page calls `onAuthorized` (`HomeFeature.navigate`). `Left(AuthSessionUnauthorized)` calls `onUnauthorized` (`SignInFeature.navigate`).
5. The error state renders `MessageView` with a retry that calls `check()` again.

## Toggle

`appIsActive`, checked in `AuthIndexCubit.check()` before the session check.

## Known gaps

- The session check is a synchronous `currentUser` lookup; it does not wait for Firebase Auth to restore a persisted session, so a cold start can route to sign-in briefly before Auth is ready.
