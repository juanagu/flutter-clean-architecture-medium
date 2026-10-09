import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/application/feature_flags.dart';
import 'package:app/src/features/auth/domain/failures/auth_session_failure.dart';
import 'package:app/src/features/auth/domain/repositories/auth_session_repository.dart';
import 'package:app/src/features/auth/presentation/cubits/auth_index_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'auth_index_state.dart';

class AuthIndexCubit extends Cubit<AuthIndexState> {
  AuthIndexCubit({
    required this._authSessionRepository,
    required this._featureConfig,
    required this._logger,
  }) : super(const AuthIndexInitial());

  final AuthSessionRepository _authSessionRepository;
  final FeatureConfig _featureConfig;
  final Logger _logger;

  Future<void> check() async {
    emit(const AuthIndexInitial());

    final isAppActive = await _isAppActive();
    if (isAppActive == null) {
      emit(const AuthIndexUnexpectedError());
      return;
    }
    if (!isAppActive) {
      emit(const AuthIndexMaintenance());
      return;
    }

    final result = await _authSessionRepository.isAuthorized();
    emit(result.fold(_stateFromFailure, (_) => const AuthIndexAuthorized()));
  }

  Future<bool?> _isAppActive() async {
    try {
      return await _featureConfig.isEnabled(FeatureFlags.appIsActive);
    } catch (error, stackTrace) {
      await _logger.recordError(error, stackTrace);
      return null;
    }
  }

  AuthIndexState _stateFromFailure(AuthSessionFailure failure) {
    return switch (failure) {
      AuthSessionUnauthorized() => const AuthIndexUnauthorized(),
      AuthSessionUnexpectedError() => const AuthIndexUnexpectedError(),
    };
  }
}
