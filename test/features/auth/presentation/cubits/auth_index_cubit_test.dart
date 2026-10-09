import 'package:app/src/application/feature_flags.dart';
import 'package:app/src/features/auth/domain/failures/auth_session_failure.dart';
import 'package:app/src/features/auth/domain/repositories/auth_session_repository.dart';
import 'package:app/src/features/auth/presentation/cubits/auth_index_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

class _FixedAuthSessionRepository implements AuthSessionRepository {
  _FixedAuthSessionRepository(this.result);

  final Either<AuthSessionFailure, Unit> result;

  @override
  Future<Either<AuthSessionFailure, Unit>> isAuthorized() async => result;
}

void main() {
  AuthIndexCubit makeCubit({
    Either<AuthSessionFailure, Unit>? session,
    bool appIsActive = true,
    Object? configFailure,
  }) {
    return AuthIndexCubit(
      authSessionRepository: _FixedAuthSessionRepository(
        session ?? right(unit),
      ),
      featureConfig: MapFeatureConfig({
        FeatureFlags.appIsActive: appIsActive,
      }, failure: configFailure),
      logger: RecordingLogger(),
    );
  }

  test('authorizes a signed-in user', () async {
    final cubit = makeCubit();

    await cubit.check();

    expect(cubit.state, isA<AuthIndexAuthorized>());
  });

  test('sends a signed-out user to sign in', () async {
    final cubit = makeCubit(session: left(const AuthSessionUnauthorized()));

    await cubit.check();

    expect(cubit.state, isA<AuthIndexUnauthorized>());
  });

  test(
    'shows maintenance when the app flag is off, before any session check',
    () async {
      final cubit = makeCubit(
        appIsActive: false,
        session: left(const AuthSessionUnexpectedError()),
      );

      await cubit.check();

      expect(cubit.state, isA<AuthIndexMaintenance>());
    },
  );

  test('reports an error when the flag source throws', () async {
    final cubit = makeCubit(configFailure: StateError('no network'));

    await cubit.check();

    expect(cubit.state, isA<AuthIndexUnexpectedError>());
  });

  test('reports a session failure', () async {
    final cubit = makeCubit(session: left(const AuthSessionUnexpectedError()));

    await cubit.check();

    expect(cubit.state, isA<AuthIndexUnexpectedError>());
  });
}
