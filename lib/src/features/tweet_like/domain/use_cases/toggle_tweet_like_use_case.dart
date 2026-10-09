import 'package:app/src/core/domain/entities/tweet.dart';
import 'package:app/src/core/domain/repositories/user_session_repository.dart';
import 'package:app/src/features/tweet_like/domain/failures/tweet_like_failure.dart';
import 'package:app/src/features/tweet_like/domain/repositories/tweet_like_repository.dart';
import 'package:app/src/features/tweet_like/domain/use_cases/tweet_like_use_case.dart';
import 'package:dartz/dartz.dart';

class ToggleTweetLikeUseCase implements TweetLikeUseCase {
  const ToggleTweetLikeUseCase({
    required this._tweetLikeRepository,
    required this._userSessionRepository,
  });

  final TweetLikeRepository _tweetLikeRepository;
  final UserSessionRepository _userSessionRepository;

  @override
  Future<Either<TweetLikeFailure, Tweet>> execute(Tweet tweet) async {
    final user = await _userSessionRepository.getCurrentUser();
    if (user == null) return left(const TweetLikeUnauthenticated());

    final toggled = tweet.toggleLike();
    final result = await _tweetLikeRepository.setLiked(
      tweet,
      user: user,
      liked: toggled.likeIt,
    );
    return result.map((_) => toggled);
  }
}
