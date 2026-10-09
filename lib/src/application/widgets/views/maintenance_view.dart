import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter/material.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  static const double _iconSize = 60;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: _iconSize,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
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
