import 'package:app/src/application/widgets/forms/form_error_message.dart';
import 'package:app/src/features/sign_in/domain/failures/sign_in_failure.dart'
    as failures;
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_cubit.dart';
import 'package:app/src/features/sign_in/presentation/widgets/sign_in_component.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localized.dart';

class _FixedSignInRepository implements SignInRepository {
  _FixedSignInRepository(this.failure);

  final failures.SignInFailure failure;

  @override
  Future<Either<failures.SignInFailure, Unit>> signIn(
    String email,
    String password,
  ) async => left(failure);
}

void main() {
  Widget component(failures.SignInFailure failure) {
    return SignInComponent(
      createCubit: () =>
          SignInCubit(signInRepository: _FixedSignInRepository(failure)),
      onAuthorized: (_) {},
      signUpAction: const Text('sign up'),
    );
  }

  Future<void> submit(WidgetTester tester, String buttonTitle) async {
    await tester.enterText(find.byType(TextFormField).first, 'a@b.co');
    await tester.enterText(find.byType(TextFormField).last, 'secret');
    await tester.tap(find.text(buttonTitle));
    await tester.pumpAndSettle();
  }

  testWidgets('shows wrong credentials inline, not as a snackbar', (
    tester,
  ) async {
    final i18n = await pumpLocalized(
      tester,
      component(const failures.SignInUnauthorized()),
    );

    await submit(tester, i18n.translate('sign_in_feature.submit_button_title'));

    expect(find.byType(FormErrorMessage), findsOneWidget);
    expect(
      find.text(i18n.translate('sign_in_feature.unauthorized_message')),
      findsOneWidget,
    );
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('sign up'), findsOneWidget);
  });

  testWidgets('shows an unexpected error as a snackbar, with no block', (
    tester,
  ) async {
    final i18n = await pumpLocalized(
      tester,
      component(const failures.SignInUnexpectedError()),
    );

    await submit(tester, i18n.translate('sign_in_feature.submit_button_title'));

    expect(find.byType(FormErrorMessage), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(i18n.translate('sign_in_feature.unexpected_message')),
      findsOneWidget,
    );
  });
}
