# sign_in

## Purpose

The sign-in screen at `/sign-in`: email and password form, with the sign-up button under it when that feature is on.

## Exposed interface

`SignInFeature` (`sign_in_feature.dart`):

- `static const String route = '/sign-in'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamedAndRemoveUntil`, clears the stack.
- `Widget buildPage()`

## States and failures

- `SignInState` (sealed): `SignInInitial`, `SignInAuthenticating`, `SignInAuthorized`, `SignInUnauthorized`, `SignInUnexpectedError`.
- `SignInFailure` (sealed): `SignInUnauthorized`, `SignInUnexpectedError`.

## Data flow

1. `SignInComponent` renders the shared `EmailPasswordForm`; submit calls `SignInCubit.signIn(email, password)`.
2. The cubit emits `SignInAuthenticating` and calls `SignInRepository.signIn`.
3. `SignInRemoteRepository` calls `AuthClient.signIn`. `AuthClientException(invalidCredentials)` maps to `SignInUnauthorized` without logging; anything else is logged and maps to `SignInUnexpectedError`.
4. `SignInAuthorized` triggers `onAuthorized` (`AuthIndexFeature.navigate`), which re-runs the entry checks. Failures show a snackbar and keep the form.
5. `signUpAction` is `SignUpFeature().buildButton()`, passed in by the Feature class and rendered as the form footer.

## Toggle

None of its own. The sign-up button it embeds hides itself when `signUpFeatureIsActive` is off.

## Known gaps

- No "forgot password" and no sign-out anywhere in the app.
