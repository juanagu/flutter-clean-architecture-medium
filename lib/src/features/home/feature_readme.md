# home

## Purpose

The home screen at `/home`: the tweet feed with the compose button. It has no logic of its own; it composes two other features.

## Exposed interface

`HomeFeature` (`home_feature.dart`):

- `static const String route = '/home'`
- `static Map<String, WidgetBuilder> generateRoutes()`
- `static Future<void> navigate(BuildContext context)`: `pushNamedAndRemoveUntil`, clears the stack.
- `Widget buildPage()`

## States and failures

None. `HomePage` is a stateless `PageContainer` with a title.

## Data flow

1. `HomeFeature.buildPage()` builds `HomePage` with `feed: TweetFeedFeature().build()` and `composeButton: TweetCreationFeature().buildFloatingButton()`.
2. `HomePage` places the feed in the body and the button as the floating action button.
3. Everything else happens inside `tweet_feed`, `tweet_like` and `tweet_creation`.

## Toggle

None of its own. The compose button hides itself when `tweetCreationIsActive` is off.

## Known gaps

- No sign-out action. The only way out is restarting the app with a cleared session.
