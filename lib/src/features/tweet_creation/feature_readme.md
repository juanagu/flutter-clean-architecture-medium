# tweet_creation

## Purpose

The compose screen at `/tweet` and the floating button on home that opens it. Posts a tweet of up to 280 characters stamped with the signed-in user and the current time.

## Exposed interface

`TweetCreationFeature` (`tweet_creation_feature.dart`):

- `static const String route = '/tweet'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamed`, so success pops back to home.
- `Widget buildPage()`
- `Widget buildFloatingButton()`: the FAB, rendered by `home` when the compose toggle is on.

## States and failures

- `TweetCreationState` (sealed): `TweetCreationInitial`, `TweetCreationTweeting`, `TweetCreationTweeted`, `TweetCreationFailed(failure)`.
- `TweetCreationFailure` (sealed): `TweetCreationUnauthenticated`, `TweetCreationUnexpectedError`.
- Entity: `TweetDraft` (content, owner, creationDate). A tweet before it has an id or likes.

## Data flow

1. `TweetComposer` is a `PageContainer` with an `X` leading, no title, and the `Tweet` pill (`PillButton`) as the app bar action; the body is a borderless text field (280 max, `minLines` 6) with a remaining-characters counter that turns `error` at 20 left. The pill is disabled until the trimmed text is non-empty (a `ValueListenableBuilder` on the controller) and calls `TweetCreationCubit.tweet(content)` with the trimmed text.
2. `AuthoredTweetCreationUseCase.execute(content)` reads `UserSessionRepository.getCurrentUser()`. No user returns `Left(TweetCreationUnauthenticated)`. Otherwise it builds a `TweetDraft` with the user and `clock().toUtc()`.
3. `TweetCreationRemoteRepository.create(draft)` writes `TweetDocument.toJson(...)` with an empty `likedBy` through `DataRemoteClient.add('tweets', ...)`. Exceptions are logged and become `TweetCreationUnexpectedError`.
4. `TweetCreationTweeted` pops the route (the composer renders read-only for the frame it exists). `TweetCreationFailed` shows a snackbar keyed by the failure and keeps the composer. While `TweetCreationTweeting`, the composer stays mounted read-only with a spinner in the pill and the `X` disabled, so a failure keeps the draft. The feed on home updates through its own stream.

The floating button on home uses `Icons.edit_outlined` with `tweet_creation_feature.title` (`New tweet`) as its tooltip; the same key names the route for the web document title.

## Toggle

`tweetCreationIsActive`, read once by `HomeFeature.buildPage()` (`FeatureGate.builder`), which renders `buildFloatingButton()` only when it is on. The `/tweet` route stays registered.

## Known gaps

- The `clock` is injectable for tests but `IocManager` has no `Clock` service; the Feature class uses `DateTime.now`.
