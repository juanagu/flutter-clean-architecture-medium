import 'package:app/src/core/presentation/pages/page_container.dart';
import 'package:app/src/core/presentation/widgets/views/maintenance_view.dart';
import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      body: MaintenceView(),
    );
  }
}
