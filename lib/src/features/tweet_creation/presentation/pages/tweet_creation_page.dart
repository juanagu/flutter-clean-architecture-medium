import 'package:app/src/core/presentation/localizations/i18n.dart';
import 'package:app/src/core/presentation/pages/page_container.dart';
import 'package:flutter/material.dart';

class TweetCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: I18n.of(context).translate('tweet_creation_title'),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 250.0,
          child: TextFormField(
            decoration: InputDecoration(
              isDense: true,
              hintText: I18n.of(context).translate('tweet_creation_hint_text'),
            ),
            autofocus: true,
            maxLength: 280,
          ),
        ),
        Divider(),
      ],
    );
  }
}
