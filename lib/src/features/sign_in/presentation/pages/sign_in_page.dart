import 'package:flutter/material.dart';
import 'package:app/src/application/pages/page_container.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    Key key,
    @required this.signInWiget,
  }) : super(key: key);

  final Widget signInWiget;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      body: signInWiget,
    );
  }
}
