import 'package:app/src/features/tweet_creation/domain/use_cases/tweet_creation_use_case.dart';
import 'package:app/src/features/tweet_creation/presentation/cubits/tweet_creation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
export 'tweet_creation_state.dart';

class TweetCreationCubit extends Cubit<TweetCreationState> {
  TweetCreationCubit({
    @required TweetCreationUseCase useCase,
  })  : _useCase = useCase,
        super(const TweetCreationState.initial());

  final TweetCreationUseCase _useCase;

  Future<void> tweet(String content) async {
    emit(const TweetCreationState.tweeting());
    var either = await _useCase.execute(content);
    either.fold(
      (error) => emit(const TweetCreationState.unexpectedError()),
      (success) => emit(const TweetCreationState.tweeted()),
    );
  }
}
