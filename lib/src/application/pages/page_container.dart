import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget floatingActionButton;
  final List<Widget> actions;

  const PageContainer({
    Key key,
    @required this.body,
    this.title,
    this.floatingActionButton,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return _hasAppBar(context)
        ? AppBar(
            title: _hasTitle() ? Text(title) : null,
            actions: actions,
          )
        : null;
  }

  bool _hasAppBar(BuildContext context) =>
      Navigator.of(context).canPop() || _hasTitle() || _hasActions();

  bool _hasTitle() => title != null && title.isNotEmpty;

  bool _hasActions() => actions != null && actions.isNotEmpty;
}
