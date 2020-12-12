import 'package:flutter/material.dart';
import 'package:app/src/core/presentation/pages/page_container.dart';

class SignInPage extends StatelessWidget {
  final Widget signInWiget;

  const SignInPage({
    Key key,
    @required this.signInWiget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      body: signInWiget,
    );
  }
}
