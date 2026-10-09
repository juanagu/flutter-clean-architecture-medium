import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:flutter/material.dart';

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
    );
  }
}
