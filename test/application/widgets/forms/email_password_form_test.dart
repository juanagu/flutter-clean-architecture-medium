import 'package:app/src/application/widgets/forms/email_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/localized.dart';

void main() {
  const labels = EmailPasswordFormLabels(
    email: 'Email',
    password: 'Password',
    submit: 'Go',
    submittingSemantics: 'Working',
  );

  testWidgets('shows translated validation messages and blocks submit', (
    tester,
  ) async {
    var submitted = false;
    final i18n = await pumpLocalized(
      tester,
      EmailPasswordForm(labels: labels, onSubmit: (_, _) => submitted = true),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(find.text(i18n.translate('form.email_required')), findsOneWidget);
    expect(find.text(i18n.translate('form.password_required')), findsOneWidget);
    expect(submitted, isFalse);
  });

  testWidgets('submits a trimmed email and the raw password', (tester) async {
    String? email;
    String? password;
    await pumpLocalized(
      tester,
      EmailPasswordForm(
        labels: labels,
        onSubmit: (e, p) {
          email = e;
          password = p;
        },
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, ' a@b.co ');
    await tester.enterText(find.byType(TextFormField).last, ' pw ');
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(email, 'a@b.co');
    expect(password, ' pw ');
  });

  testWidgets('renders the footer under the form in Spanish too', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      EmailPasswordForm(
        labels: labels,
        onSubmit: (_, _) {},
        footer: const Text('footer'),
      ),
      languageCode: 'es',
    );

    expect(find.text('footer'), findsOneWidget);
  });
}
