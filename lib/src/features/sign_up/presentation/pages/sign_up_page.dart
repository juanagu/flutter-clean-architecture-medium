import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Pushed over sign-in, so the app bar carries only the back arrow; the
/// heading lives in the body.
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return PageContainer(body: body, columnWidth: kColumnWidthForm);
  }
}
