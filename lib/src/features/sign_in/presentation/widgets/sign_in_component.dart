import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/widgets/forms/email_password_form.dart';
import 'package:app/src/application/widgets/snack_bars.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInComponent extends StatelessWidget {
  const SignInComponent({
    super.key,
    required this.createCubit,
    required this.onAuthorized,
    this.signUpAction,
  });

  final SignInCubit Function() createCubit;
  final void Function(BuildContext context) onAuthorized;

  /// Rendered under the form; the feature that owns sign-up provides it.
  final Widget? signUpAction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createCubit(),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: _listen,
        builder: _buildByState,
      ),
    );
  }

  /// Wrong credentials are inline in the form; only a failure the user
  /// cannot fix by retyping is a snackbar.
  void _listen(BuildContext context, SignInState state) {
    switch (state) {
      case SignInAuthorized():
        onAuthorized(context);
      case SignInUnexpectedError():
        showTranslatedSnackBar(context, 'sign_in_feature.unexpected_message');
      case SignInInitial():
      case SignInAuthenticating():
      case SignInUnauthorized():
        break;
    }
  }

  /// The form stays mounted across every state, so a failed attempt keeps
  /// what was typed; the final one renders it submitting for its one frame.
  Widget _buildByState(BuildContext context, SignInState state) {
    return switch (state) {
      SignInInitial() || SignInUnexpectedError() => _buildForm(context),
      SignInAuthenticating() ||
      SignInAuthorized() => _buildForm(context, isSubmitting: true),
      SignInUnauthorized() => _buildForm(
        context,
        errorKey: 'sign_in_feature.unauthorized_message',
      ),
    };
  }

  Widget _buildForm(
    BuildContext context, {
    bool isSubmitting = false,
    String? errorKey,
  }) {
    final i18n = I18n.of(context);
    return EmailPasswordForm(
      labels: EmailPasswordFormLabels(
        heading: i18n.translate('sign_in_feature.title'),
        email: i18n.translate('sign_in_feature.email_label'),
        password: i18n.translate('sign_in_feature.password_label'),
        submit: i18n.translate('sign_in_feature.submit_button_title'),
        submittingSemantics: i18n.translate(
          'sign_in_feature.authenticating_message_semantics',
        ),
      ),
      isSubmitting: isSubmitting,
      errorText: errorKey == null ? null : i18n.translate(errorKey),
      focusPasswordOnError: true,
      onSubmit: context.read<SignInCubit>().signIn,
      footer: signUpAction,
    );
  }
}
