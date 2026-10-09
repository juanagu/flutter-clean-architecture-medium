# tweet_like

## Purpose

The like button and count on each feed row. Toggles the like optimistically and persists who liked the tweet. It has no route.

## Exposed interface

`TweetLikeFeature` (`tweet_like_feature.dart`):

- `Widget build(Tweet tweet)`: one button per tweet, keyed by `like-<tweet.id>`.

No `route`, `generateRoutes()` or `navigate()`.

## States and failures

- `TweetLikeState` (sealed, each carries the `tweet` to show): `TweetLikeIdle`, `TweetLikeSending`, `TweetLikeFailed(failure)`.
- `TweetLikeFailure` (sealed): `TweetLikeUnauthenticated`, `TweetLikeUnexpectedError`.

## Data flow

1. `TweetLikeButton` is a `StatefulWidget` that creates one `TweetLikeCubit` seeded with the row's `Tweet` and keeps it across feed updates. When the feed hands it a newer `Tweet`, `didUpdateWidget` calls `cubit.sync(tweet)`, which adopts it unless a like is in flight.
2. `toggle()` is ignored while `TweetLikeSending`. Otherwise it emits `TweetLikeSending(before.toggleLike())` so the UI flips at once.
3. `ToggleTweetLikeUseCase.execute(before)` reads the signed-in user from `UserSessionRepository`. No user returns `Left(TweetLikeUnauthenticated)`. Otherwise it calls `TweetLikeRepository.setLiked(before, user:, liked: toggled.likeIt)` and returns the toggled tweet.
4. `TweetLikeRemoteRepository.setLiked` calls `DataRemoteClient.updateSet('tweets', id, 'likedBy', add: [user.id])` or `remove: [user.id]`. The write is atomic on the set, so concurrent likers never overwrite each other. Exceptions are logged and become `TweetLikeUnexpectedError`.
5. `Right(tweet)` emits `TweetLikeIdle(tweet)`. `Left` emits `TweetLikeFailed(before, failure)`, rolling the UI back, and the button shows a snackbar keyed by the failure.
   The control is a 20 heart in a 44x44 target (`onSurfaceVariant`, `tertiary` when liked) with the count in `labelMedium` next to it, hidden at 0. Its semantics are one toggle button labelled `Like`/`Unlike` plus the count. While sending it ignores taps but keeps its colours.
6. The feed stream then delivers the stored document; `TweetDocument.fromRemote` derives `likes` from `likedBy.length` and `likeIt` from whether the signed-in user is in the set, and `sync` adopts it.

## Toggle

None.

## Known gaps

- The two `updateSet` writes (`add` then `remove`) are separate requests; a toggle only ever sends one of them, so this never matters today.
