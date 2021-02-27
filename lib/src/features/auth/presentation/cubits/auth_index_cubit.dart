import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/features/auth/auth_index_feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/features/auth/domain/repositories/auth_session_repository.dart';
import 'package:meta/meta.dart';

import 'auth_index_state.dart';

export 'auth_index_state.dart';

class AuthIndexCubit extends Cubit<AuthIndexState> {
  AuthIndexCubit({
    @required AuthSessionRepository authSessionRepository,
    @required FeatureConfig featureConfig,
  })  : _authSessionRepository = authSessionRepository,
        _featureConfig = featureConfig,
        super(const AuthIndexState.initial());
  final AuthSessionRepository _authSessionRepository;
  final FeatureConfig _featureConfig;

  Future<void> check() async {
    var isAppActive = await _featureConfig.isEnabled(AuthIndexFeature.key);
    if (!isAppActive) {
      emit(const AuthIndexState.maintenance());
      return;
    }

    var either = await _authSessionRepository.isAuthorized();
    either.fold(
      (error) => error.when(
        unauthorized: () => emit(const AuthIndexState.unauthorized()),
        unexpectedError: () => emit(const AuthIndexState.unexpectedError()),
      ),
      (authorized) => emit(const AuthIndexState.authorized()),
    );
  }
}
