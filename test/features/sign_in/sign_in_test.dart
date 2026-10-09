import 'package:app/src/features/sign_in/data/remote/sign_in_remote_repository.dart';
import 'package:app/src/features/sign_in/domain/failures/sign_in_failure.dart'
    as failures;
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_cubit.dart';
import 'package:app/src/integrations/in_memory/in_memory_auth_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

class _FixedSignInRepository implements SignInRepository {
  _FixedSignInRepository(this.result);

  final Either<failures.SignInFailure, Unit> result;

  @override
  Future<Either<failures.SignInFailure, Unit>> signIn(
    String email,
    String password,
  ) async => result;
}

void main() {
  group('SignInRemoteRepository', () {
    late RecordingLogger logger;
    late SignInRemoteRepository repository;

    setUp(() {
      logger = RecordingLogger();
      repository = SignInRemoteRepository(
        authClient: InMemoryAuthClient(accounts: {'a@b.co': 'secret'}),
        logger: logger,
      );
    });

    test('succeeds with the right credentials', () async {
      final result = await repository.signIn('a@b.co', 'secret');

      expect(result.isRight(), isTrue);
    });

    test('maps bad credentials to unauthorized without logging', () async {
      final result = await repository.signIn('a@b.co', 'wrong');

      expect(
        result,
        left<failures.SignInFailure, Unit>(const failures.SignInUnauthorized()),
      );
      expect(logger.errors, isEmpty);
    });
  });

  group('SignInCubit', () {
    test('goes through authenticating to authorized', () async {
      final cubit = SignInCubit(
        signInRepository: _FixedSignInRepository(right(unit)),
      );
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([isA<SignInAuthenticating>(), isA<SignInAuthorized>()]),
      );

      await cubit.signIn('a@b.co', 'secret');

      await expectation;
    });

    test('maps each failure to its state', () async {
      final cubit = SignInCubit(
        signInRepository: _FixedSignInRepository(
          left(const failures.SignInUnexpectedError()),
        ),
      );

      await cubit.signIn('a@b.co', 'secret');

      expect(cubit.state, isA<SignInUnexpectedError>());
    });
  });
}
