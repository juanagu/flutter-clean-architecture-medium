import 'package:app/src/application/widgets/forms/email_password_form.dart';
import 'package:app/src/application/widgets/forms/form_error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/localized.dart';

void main() {
  const labels = EmailPasswordFormLabels(
    heading: 'Heading',
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

  testWidgets('renders the heading and the footer in Spanish too', (
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

    expect(find.text('Heading'), findsOneWidget);
    expect(find.text('footer'), findsOneWidget);
  });

  testWidgets('shows the inline error block only when given one', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      EmailPasswordForm(labels: labels, onSubmit: (_, _) {}),
    );
    expect(find.byType(FormErrorMessage), findsNothing);

    await pumpLocalized(
      tester,
      EmailPasswordForm(labels: labels, onSubmit: (_, _) {}, errorText: 'Nope'),
    );

    expect(find.byType(FormErrorMessage), findsOneWidget);
    expect(find.text('Nope'), findsOneWidget);
  });

  testWidgets('toggles the password between hidden and shown', (tester) async {
    final i18n = await pumpLocalized(
      tester,
      EmailPasswordForm(labels: labels, onSubmit: (_, _) {}),
    );
    final password = find.byType(TextFormField).last;
    await tester.enterText(password, 'secret');
    await tester.pump();
    expect(_isObscured(tester), isTrue);

    await tester.tap(find.byTooltip(i18n.translate('form.show_password')));
    await tester.pump();

    expect(_isObscured(tester), isFalse);
    expect(
      find.byTooltip(i18n.translate('form.hide_password')),
      findsOneWidget,
    );
  });

  testWidgets('hides the footer and shows progress while submitting', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      EmailPasswordForm(
        labels: labels,
        onSubmit: (_, _) {},
        isSubmitting: true,
        footer: const Text('footer'),
      ),
    );

    expect(find.text('footer'), findsNothing);
    expect(find.text('Go'), findsNothing);
    expect(find.bySemanticsLabel('Working'), findsOneWidget);
  });
}

bool _isObscured(WidgetTester tester) {
  return tester
      .widget<EditableText>(find.byType(EditableText).last)
      .obscureText;
}
