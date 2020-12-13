import 'package:flutter/material.dart';
import 'package:app/src/application/presentation/pages/page_container.dart';
import 'package:app/src/application/presentation/localizations/i18n.dart';

class SignUpPage extends StatelessWidget {
  final Widget signUpWidget;

  const SignUpPage({
    Key key,
    @required this.signUpWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('sign_up_title'),
      body: signUpWidget,
    );
  }
}
