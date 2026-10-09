import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:flutter/material.dart';

/// The feed fills the column edge to edge (rows carry their own padding so
/// dividers run the full width) and the column shows its hairline edges
/// once the viewport is wider than it.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.feed, required this.composeButton});

  final Widget feed;
  final Widget composeButton;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('home_feature.title'),
      body: feed,
      floatingActionButton: composeButton,
      gutter: false,
      columnEdges: true,
    );
  }
}
