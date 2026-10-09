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

1. `HomeFeature.buildPage()` wraps `HomePage` in `FeatureGate.builder` on `tweetCreationIsActive` and builds it with `feed: TweetFeedFeature().build(hasFloatingAction: canCompose)` and `composeButton: TweetCreationFeature().buildFloatingButton()`.
2. `HomePage` is a `PageContainer` with the `Home` title, no gutter (rows pad themselves so dividers run edge to edge) and column edges at 768+; the feed is the body and the button the floating action button.
3. Everything else happens inside `tweet_feed`, `tweet_like` and `tweet_creation`.

## Toggle

`tweetCreationIsActive` is read here only to size the feed's bottom padding (88 with the button, 16 without). The compose button still hides itself through its own gate in `tweet_creation`.

## Known gaps

- No sign-out action. The only way out is restarting the app with a cleared session.
