import 'package:app/src/features/tweet_creation/presentation/widgets/tweet_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localized.dart';

void main() {
  FilledButton pill(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  testWidgets('enables the pill only once there is non-blank text', (
    tester,
  ) async {
    String? submitted;
    final i18n = await pumpLocalized(
      tester,
      TweetComposer(onSubmit: (content) => submitted = content),
    );
    expect(pill(tester).enabled, isFalse);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    expect(pill(tester).enabled, isFalse);

    await tester.enterText(find.byType(TextField), ' hi ');
    await tester.pump();
    expect(pill(tester).enabled, isTrue);

    await tester.tap(
      find.text(i18n.translate('tweet_creation_feature.submit_button_title')),
    );
    expect(submitted, 'hi');
  });

  testWidgets('shows a spinner in the pill while submitting', (tester) async {
    final i18n = await pumpLocalized(
      tester,
      TweetComposer(onSubmit: (_) {}, isSubmitting: true),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        i18n.translate('tweet_creation_feature.tweeting_message_semantics'),
      ),
      findsOneWidget,
    );
    expect(tester.widget<TextField>(find.byType(TextField)).readOnly, isTrue);
  });

  testWidgets('counts down and turns to error at 20 left', (tester) async {
    await pumpLocalized(tester, TweetComposer(onSubmit: (_) {}));
    expect(find.text('${TweetComposer.maxLength}'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      'x' * (TweetComposer.maxLength - 21),
    );
    await tester.pump();
    expect(_counterColor(tester, '21'), _colors(tester).onSurfaceVariant);

    await tester.enterText(
      find.byType(TextField),
      'x' * (TweetComposer.maxLength - 20),
    );
    await tester.pump();

    expect(_counterColor(tester, '20'), _colors(tester).error);
  });
}

ColorScheme _colors(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(TextField))).colorScheme;

Color? _counterColor(WidgetTester tester, String value) =>
    tester.widget<Text>(find.text(value)).style?.color;
