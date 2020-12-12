import 'package:app/src/core/presentation/localizations/i18n.dart';
import 'package:app/src/core/presentation/pages/page_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('home_title'),
      body: Center(
        child: Text('home'),
      ),
    );
  }
}
