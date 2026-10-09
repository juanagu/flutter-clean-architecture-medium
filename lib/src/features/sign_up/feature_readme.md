# sign_up

## Purpose

Account creation at `/sign-up`, and the button that opens it from the sign-in screen.

## Exposed interface

`SignUpFeature` (`sign_up_feature.dart`):

- `static const String route = '/sign-up'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamed`, so back returns to sign-in.
- `Widget buildPage()`
- `Widget buildButton()`: the toggle-aware link, rendered by `sign_in`.

## States and failures

- `SignUpState` (sealed): `SignUpInitial`, `SignUpCreating`, `SignUpRegistered`, `SignUpEmailAlreadyInUse`, `SignUpWeakPassword`, `SignUpUnexpectedError`.
- `SignUpFailure` (sealed): `SignUpEmailAlreadyInUse`, `SignUpWeakPassword`, `SignUpUnexpectedError`.

## Data flow

1. `SignUpComponent` renders `EmailPasswordForm`; submit calls `SignUpCubit.signUp`.
2. `SignUpRemoteRepository` calls `AuthClient.signUp`. `emailAlreadyInUse` and `weakPassword` map to their failures without logging; other codes and exceptions are logged and map to `SignUpUnexpectedError`.
3. `SignUpRegistered` triggers `onRegistered` (`AuthIndexFeature.navigate`). The auth client has signed the new user in, so the entry screen routes to home.
4. Failures show a snackbar and keep the form. While `SignUpCreating`, the form stays mounted read-only with progress in the button, so a failure keeps what was typed.

## Toggle

`signUpFeatureIsActive`, checked by the `FeatureGate` that `buildButton()` wraps around `SignUpButton`. Off renders `SizedBox.shrink()`. The `/sign-up` route stays registered.

## Known gaps

- Password strength is only what the auth client enforces (Firebase: 6 characters; in-memory: 6 characters). The form itself only requires a non-empty password.
