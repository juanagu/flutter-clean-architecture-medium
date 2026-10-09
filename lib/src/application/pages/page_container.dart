import 'package:flutter/material.dart';

/// Scaffold shared by every page: an app bar only when there is something to
/// put in it, and a horizontal gutter proportional to the viewport.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.body,
    this.title,
    this.floatingActionButton,
    this.actions,
  });

  static const double _gutterFraction = 0.05;

  final Widget body;
  final String? title;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final gutter = MediaQuery.sizeOf(context).width * _gutterFraction;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? _buildAppBar(BuildContext context) {
    if (!_hasAppBar(context)) return null;

    final title = this.title;
    return AppBar(title: title == null ? null : Text(title), actions: actions);
  }

  bool _hasAppBar(BuildContext context) =>
      Navigator.of(context).canPop() || _hasTitle || _hasActions;

  bool get _hasTitle => title?.isNotEmpty ?? false;

  bool get _hasActions => actions?.isNotEmpty ?? false;
}
