import 'package:app/src/application/widgets/views/maintenance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/pages/page_container.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/features/auth/presentation/cubits/auth_index_cubit.dart';

class AuthIndexPage extends StatelessWidget {
  final AuthIndexCubit cubit;
  final Function(BuildContext) onAuthorized;
  final Function(BuildContext) onUnauthorized;
  final Function(BuildContext) onUnexpected;

  AuthIndexPage({
    Key key,
    @required this.cubit,
    @required this.onAuthorized,
    @required this.onUnauthorized,
    @required this.onUnexpected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      body: BlocProvider(
        create: (_) => cubit..check(),
        child: BlocConsumer<AuthIndexCubit, AuthIndexState>(
          listener: _listenByState,
          builder: _buildByState,
        ),
      ),
    );
  }

  void _listenByState(
    BuildContext context,
    AuthIndexState state,
  ) {
    state.maybeWhen(
      authorized: () => onAuthorized(context),
      unauthorized: () => onUnauthorized(context),
      unexpectedError: () => onUnexpected(context),
      orElse: () {},
    );
  }

  Widget _buildByState(
    BuildContext context,
    AuthIndexState state,
  ) {
    return state.maybeWhen(
      authorized: () => _buildAuthorizedView(context),
      unauthorized: () => _buildUnauthorizedView(context),
      unexpectedError: () => _buildUnexpectedErrorView(context),
      maintenance: () => MaintenceView(),
      orElse: () => _buildInitialView(context),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: CircularIndicator(
        semanticsValue:
            I18n.of(context).translate('auth_index_loading_semantic'),
      ),
    );
  }

  Widget _buildAuthorizedView(BuildContext context) {
    return Center(
      child: Icon(Icons.check),
    );
  }

  Widget _buildUnauthorizedView(BuildContext context) {
    return Center(
      child: Icon(Icons.block),
    );
  }

  Widget _buildUnexpectedErrorView(BuildContext context) {
    return Center(
      child: Icon(Icons.error),
    );
  }
}
