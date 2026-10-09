import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('sign_up_feature.title'),
      body: body,
    );
  }
}
