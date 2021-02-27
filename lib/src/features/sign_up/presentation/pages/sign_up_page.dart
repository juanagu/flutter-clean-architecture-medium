import 'package:flutter/material.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/localizations/i18n.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    Key key,
    @required this.signUpWidget,
  }) : super(key: key);
  final Widget signUpWidget;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('sign_up_feature.title'),
      body: signUpWidget,
    );
  }
}
