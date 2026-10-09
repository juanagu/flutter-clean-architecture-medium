import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/widgets/views/message_view.dart';
import 'package:flutter/material.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.build_outlined,
      message: I18n.of(context).translate('maintenance_message'),
    );
  }
}
