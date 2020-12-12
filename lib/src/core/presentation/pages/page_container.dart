import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget body;
  final String title;
  const PageContainer({
    Key key,
    @required this.body,
    this.title,
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
    );
  }

  AppBar _buildAppBar() {
    return title != null && title.isNotEmpty
        ? AppBar(title: Text(title))
        : null;
  }
}
