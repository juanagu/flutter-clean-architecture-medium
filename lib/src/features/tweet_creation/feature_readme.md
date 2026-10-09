# tweet_creation

## Purpose

The compose screen at `/tweet` and the floating button on home that opens it. Posts a tweet of up to 280 characters stamped with the signed-in user and the current time.

## Exposed interface

`TweetCreationFeature` (`tweet_creation_feature.dart`):

- `static const String route = '/tweet'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamed`, so success pops back to home.
- `Widget buildPage()`
- `Widget buildFloatingButton()`: the toggle-aware FAB, rendered by `home`.

## States and failures

- `TweetCreationState` (sealed): `TweetCreationInitial`, `TweetCreationTweeting`, `TweetCreationTweeted`, `TweetCreationFailed(failure)`.
- `TweetCreationFailure` (sealed): `TweetCreationUnauthenticated`, `TweetCreationUnexpectedError`.
- Entity: `TweetDraft` (content, owner, creationDate). A tweet before it has an id or likes.

## Data flow

1. `TweetComposer` (text field, 280 max, check icon in the app bar) calls `TweetCreationCubit.tweet(content)` with trimmed, non-empty text.
2. `AuthoredTweetCreationUseCase.execute(content)` reads `UserSessionRepository.getCurrentUser()`. No user returns `Left(TweetCreationUnauthenticated)`. Otherwise it builds a `TweetDraft` with the user and `clock().toUtc()`.
3. `TweetCreationRemoteRepository.create(draft)` writes `TweetDocument.toJson(...)` with an empty `likedBy` through `DataRemoteClient.add('tweets', ...)`. Exceptions are logged and become `TweetCreationUnexpectedError`.
4. `TweetCreationTweeted` pops the route. `TweetCreationFailed` shows a snackbar keyed by the failure and keeps the composer. While `TweetCreationTweeting`, the composer stays mounted read-only with progress in the app bar, so a failure keeps the draft. The feed on home updates through its own stream.

## Toggle

`tweetCreationIsActive`, checked by the `FeatureGate` that `buildFloatingButton()` wraps around `TweetCreationFloatingButton`. Off renders `SizedBox.shrink()`. The `/tweet` route stays registered.

## Known gaps

- The `clock` is injectable for tests but `IocManager` has no `Clock` service; the Feature class uses `DateTime.now`.
