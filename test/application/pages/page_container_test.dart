import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/localized.dart';

void main() {
  const bodyKey = Key('body');
  const gutters = Space.s4 * 2;

  testWidgets('fills the viewport minus the gutters at 390', (tester) async {
    await pumpLocalized(
      tester,
      const PageContainer(body: SizedBox.expand(key: bodyKey)),
    );

    expect(tester.getSize(find.byKey(bodyKey)).width, 390 - gutters);
  });

  testWidgets('caps the column at 768 and centres it', (tester) async {
    await pumpLocalized(
      tester,
      const PageContainer(body: SizedBox.expand(key: bodyKey)),
      viewport: const Size(768, 1024),
    );

    final rect = tester.getRect(find.byKey(bodyKey));
    expect(rect.width, kColumnWidthFeed - gutters);
    expect(rect.center.dx, 768 / 2);
  });

  testWidgets('uses the narrower column for forms without a gutter', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      const PageContainer(
        body: SizedBox.expand(key: bodyKey),
        columnWidth: kColumnWidthForm,
        gutter: false,
      ),
      viewport: const Size(1280, 800),
    );

    expect(tester.getSize(find.byKey(bodyKey)).width, kColumnWidthForm);
  });

  testWidgets('shows an app bar with the title aligned to the column', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      const PageContainer(
        title: 'Home',
        body: SizedBox.expand(key: bodyKey),
      ),
      viewport: const Size(1280, 800),
    );

    final column = tester.getRect(find.byKey(bodyKey));
    final title = tester.getRect(find.text('Home'));
    expect(find.byType(AppBar), findsOneWidget);
    expect(title.left, column.left);
  });
}
