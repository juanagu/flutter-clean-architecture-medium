# tweet_feed

## Purpose

The live list of tweets, newest first, embedded in the home screen. It has no route. Each row gets a like control from `tweet_like`.

## Exposed interface

`TweetFeedFeature` (`tweet_feed_feature.dart`):

- `Widget build()`

No `route`, `generateRoutes()` or `navigate()`.

## States and failures

- `TweetFeedState` (sealed): `TweetFeedInitial`, `TweetFeedLoading`, `TweetFeedFound(items)`, `TweetFeedEmpty`, `TweetFeedUnexpectedError`.
- No failure type. The repository returns a `Stream<List<Tweet>>` and delivers errors on the stream.
- Presentation model: `TweetItem` (tweet plus `timeAgo`), built by `TweetItemMapper` with `RelativeTimeFormatter`.

## Data flow

1. `TweetFeedComponent` creates `TweetFeedCubit` and calls `subscribe(languageCode:)` with the locale from `Localizations.localeOf`, which emits `TweetFeedLoading`.
2. `SortedTweetFeedUseCase.execute()` is `TweetFeedRepository.watch()` mapped through `BoundedTweetFeedSorter(InsertionTweetFeedSorter())`, limit 500: the first 500 are sorted by `Tweet.compareTo` (newest first, then most liked), the rest appended as they came.
3. `TweetFeedRemoteRepository.watch()` resolves the signed-in user once through `UserSessionRepository`, then maps `DataRemoteClient.watch('tweets', orderBy: 'creationDate', descending: true)` through `TweetDocument.fromRemote(document, currentUserId:)`, which derives `likes` and `likeIt` from `likedBy`.
4. The cubit holds the `StreamSubscription`. An empty list emits `TweetFeedEmpty`; otherwise `TweetFeedFound` with mapped items. A stream error is logged and emits `TweetFeedUnexpectedError`. `close()` cancels the subscription; `subscribe()` cancels any previous one synchronously before listening again, so overlapping calls cannot leak one.
5. The component renders a spinner, a `ListView.separated` of `TweetFeedListItem`s with `likeActionBuilder(tweet)` per row, an empty `MessageView`, or an error `MessageView` with a retry that calls `subscribe()`.

`likeActionBuilder` is `TweetLikeFeature().build`, passed in by the Feature class.

## Toggle

None.

## Known gaps

- No pagination; the whole collection is streamed.
- Rows show the owner's email, not a display name.
