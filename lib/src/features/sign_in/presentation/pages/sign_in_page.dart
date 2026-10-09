import 'package:app/src/application/pages/page_container.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return PageContainer(body: body);
  }
}
