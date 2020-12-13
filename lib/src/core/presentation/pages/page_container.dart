import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget floatingActionButton;
  const PageContainer({
    Key key,
    @required this.body,
    this.title,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar _buildAppBar() {
    return title != null && title.isNotEmpty
        ? AppBar(title: Text(title))
        : null;
  }
}
