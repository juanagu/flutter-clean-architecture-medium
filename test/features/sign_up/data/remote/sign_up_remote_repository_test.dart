import 'package:app/src/features/sign_up/data/remote/sign_up_remote_repository.dart';
import 'package:app/src/features/sign_up/domain/failures/sign_up_failure.dart';
import 'package:app/src/integrations/in_memory/in_memory_auth_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

void main() {
  late RecordingLogger logger;
  late SignUpRemoteRepository repository;

  setUp(() {
    logger = RecordingLogger();
    repository = SignUpRemoteRepository(
      authClient: InMemoryAuthClient(accounts: {'taken@b.co': 'secret1'}),
      logger: logger,
    );
  });

  test('registers a new account', () async {
    final result = await repository.signUp('new@b.co', 'secret1');

    expect(result.isRight(), isTrue);
  });

  test('maps a taken email', () async {
    final result = await repository.signUp('taken@b.co', 'secret1');

    expect(result, left<SignUpFailure, Unit>(const SignUpEmailAlreadyInUse()));
    expect(logger.errors, isEmpty);
  });

  test('maps a weak password', () async {
    final result = await repository.signUp('new@b.co', '123');

    expect(result, left<SignUpFailure, Unit>(const SignUpWeakPassword()));
  });
}
