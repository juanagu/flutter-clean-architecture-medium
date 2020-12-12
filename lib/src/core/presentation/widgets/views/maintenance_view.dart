import 'package:app/src/core/presentation/localizations/i18n.dart';
import 'package:flutter/material.dart';

class MaintenceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 60.0,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              I18n.of(context).translate('maintenance_message'),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
