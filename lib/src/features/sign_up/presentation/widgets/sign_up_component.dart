import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:app/src/application/widgets/forms/email_password_form.dart';
import 'package:app/src/application/widgets/snack_bars.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpComponent extends StatelessWidget {
  const SignUpComponent({
    super.key,
    required this.createCubit,
    required this.onRegistered,
  });

  final SignUpCubit Function() createCubit;
  final void Function(BuildContext context) onRegistered;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: _listen,
        builder: _buildByState,
      ),
    );
  }

  /// Input failures are inline in the form; only a failure the user cannot
  /// fix by retyping is a snackbar.
  void _listen(BuildContext context, SignUpState state) {
    switch (state) {
      case SignUpRegistered():
        onRegistered(context);
      case SignUpUnexpectedError():
        showTranslatedSnackBar(context, 'sign_up_feature.unexpected_message');
      case SignUpInitial():
      case SignUpCreating():
      case SignUpEmailAlreadyInUse():
      case SignUpWeakPassword():
        break;
    }
  }

  /// The form stays mounted across every state, so a failed attempt keeps
  /// what was typed; the final one renders it submitting for its one frame.
  Widget _buildByState(BuildContext context, SignUpState state) {
    return switch (state) {
      SignUpInitial() || SignUpUnexpectedError() => _buildForm(context),
      SignUpCreating() ||
      SignUpRegistered() => _buildForm(context, isSubmitting: true),
      SignUpEmailAlreadyInUse() => _buildForm(
        context,
        errorKey: 'sign_up_feature.email_already_in_use',
      ),
      SignUpWeakPassword() => _buildForm(
        context,
        errorKey: 'sign_up_feature.weak_password',
        focusPassword: true,
      ),
    };
  }

  Widget _buildForm(
    BuildContext context, {
    bool isSubmitting = false,
    String? errorKey,
    bool focusPassword = false,
  }) {
    final i18n = I18n.of(context);
    return EmailPasswordForm(
      labels: EmailPasswordFormLabels(
        heading: i18n.translate('sign_up_feature.title'),
        email: i18n.translate('sign_up_feature.email_label'),
        password: i18n.translate('sign_up_feature.password_label'),
        submit: i18n.translate('sign_up_feature.submit_button_title'),
        submittingSemantics: i18n.translate(
          'sign_up_feature.creating_message_semantics',
        ),
      ),
      isSubmitting: isSubmitting,
      errorText: errorKey == null ? null : i18n.translate(errorKey),
      focusPasswordOnError: focusPassword,
      passwordHelperText: i18n.translate('sign_up_feature.password_helper'),
      topSpacing: Space.s2,
      onSubmit: context.read<SignUpCubit>().signUp,
    );
  }
}
