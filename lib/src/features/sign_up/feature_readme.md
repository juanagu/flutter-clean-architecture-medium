# sign_up

## Purpose

Account creation at `/sign-up`, and the button that opens it from the sign-in screen.

## Exposed interface

`SignUpFeature` (`sign_up_feature.dart`):

- `static const String route = '/sign-up'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamed`, so back returns to sign-in.
- `Widget buildPage()`
- `Widget buildButton()`: the toggle-aware prompt plus link (`Don't have an account?` / `Create an account`), rendered by `sign_in` under its form.

## States and failures

- `SignUpState` (sealed): `SignUpInitial`, `SignUpCreating`, `SignUpRegistered`, `SignUpEmailAlreadyInUse`, `SignUpWeakPassword`, `SignUpUnexpectedError`.
- `SignUpFailure` (sealed): `SignUpEmailAlreadyInUse`, `SignUpWeakPassword`, `SignUpUnexpectedError`.

## Data flow

1. `SignUpComponent` renders `EmailPasswordForm` with the `Create your account` heading in the body and `At least 6 characters` as the password helper; submit calls `SignUpCubit.signUp`. The page is pushed over sign-in, so its app bar carries only the back arrow.
2. `SignUpRemoteRepository` calls `AuthClient.signUp`. `emailAlreadyInUse` and `weakPassword` map to their failures without logging; other codes and exceptions are logged and map to `SignUpUnexpectedError`.
3. `SignUpRegistered` triggers `onRegistered` (`AuthIndexFeature.navigate`). The auth client has signed the new user in, so the entry screen routes to home.
4. `SignUpEmailAlreadyInUse` and `SignUpWeakPassword` are passed to the form as `errorText`, an inline block above the button; the weak-password one also moves focus to the password. `SignUpUnexpectedError` is a snackbar. While `SignUpCreating`, the form stays mounted read-only with progress in the button, so a failure keeps what was typed.

## Toggle

`signUpFeatureIsActive`, checked by the `FeatureGate` that `buildButton()` wraps around `SignUpButton`. Off renders `SizedBox.shrink()`. The `/sign-up` route stays registered.

## Known gaps

- Password strength is only what the auth client enforces (Firebase: 6 characters; in-memory: 6 characters). The form itself only requires a non-empty password.
