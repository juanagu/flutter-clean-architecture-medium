import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/application/widgets/views/maintenance_view.dart';
import 'package:app/src/application/widgets/views/message_view.dart';
import 'package:app/src/features/auth/presentation/cubits/auth_index_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef AuthIndexNavigation = void Function(BuildContext context);

/// Entry screen: decides between maintenance, home and sign-in.
class AuthIndexPage extends StatelessWidget {
  const AuthIndexPage({
    super.key,
    required this.createCubit,
    required this.onAuthorized,
    required this.onUnauthorized,
  });

  final AuthIndexCubit Function() createCubit;
  final AuthIndexNavigation onAuthorized;
  final AuthIndexNavigation onUnauthorized;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      body: BlocProvider(
        create: (_) => createCubit()..check(),
        child: BlocConsumer<AuthIndexCubit, AuthIndexState>(
          listener: _listen,
          builder: _buildByState,
        ),
      ),
    );
  }

  void _listen(BuildContext context, AuthIndexState state) {
    switch (state) {
      case AuthIndexAuthorized():
        onAuthorized(context);
      case AuthIndexUnauthorized():
        onUnauthorized(context);
      case AuthIndexInitial():
      case AuthIndexUnexpectedError():
      case AuthIndexMaintenance():
        break;
    }
  }

  Widget _buildByState(BuildContext context, AuthIndexState state) {
    return switch (state) {
      AuthIndexInitial() => _buildLoading(context),
      AuthIndexAuthorized() => const Center(child: Icon(Icons.check)),
      AuthIndexUnauthorized() => const Center(child: Icon(Icons.block)),
      AuthIndexUnexpectedError() => _buildError(context),
      AuthIndexMaintenance() => const MaintenanceView(),
    };
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularIndicator(
        semanticsLabel: I18n.of(context)
            .translate('auth_index_feature.loading_semantic'),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final i18n = I18n.of(context);
    return MessageView(
      icon: Icons.error_outline,
      message: i18n.translate('auth_index_feature.unexpected_message'),
      action: FilledButton.tonal(
        onPressed: () => context.read<AuthIndexCubit>().check(),
        child: Text(i18n.translate('retry_button_title')),
      ),
    );
  }
}
