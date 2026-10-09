import 'package:app/src/features/tweet_creation/domain/use_cases/tweet_creation_use_case.dart';
import 'package:app/src/features/tweet_creation/presentation/cubits/tweet_creation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'tweet_creation_state.dart';

class TweetCreationCubit extends Cubit<TweetCreationState> {
  TweetCreationCubit({required this._useCase})
    : super(const TweetCreationInitial());

  final TweetCreationUseCase _useCase;

  Future<void> tweet(String content) async {
    emit(const TweetCreationTweeting());
    final result = await _useCase.execute(content);
    emit(
      result.fold(TweetCreationFailed.new, (_) => const TweetCreationTweeted()),
    );
  }
}
