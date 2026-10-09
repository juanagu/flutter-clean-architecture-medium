import 'package:app/src/application/localizations/i18n.dart';
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

  void _listen(BuildContext context, SignUpState state) {
    switch (state) {
      case SignUpRegistered():
        onRegistered(context);
      case SignUpEmailAlreadyInUse():
        showTranslatedSnackBar(context, 'sign_up_feature.email_already_in_use');
      case SignUpWeakPassword():
        showTranslatedSnackBar(context, 'sign_up_feature.weak_password');
      case SignUpUnexpectedError():
        showTranslatedSnackBar(context, 'sign_up_feature.unexpected_message');
      case SignUpInitial():
      case SignUpCreating():
        break;
    }
  }

  /// The form stays mounted across every state but the final one, so a
  /// failed attempt keeps what was typed.
  Widget _buildByState(BuildContext context, SignUpState state) {
    return switch (state) {
      SignUpRegistered() => const Center(child: Icon(Icons.check)),
      SignUpInitial() ||
      SignUpCreating() ||
      SignUpEmailAlreadyInUse() ||
      SignUpWeakPassword() ||
      SignUpUnexpectedError() => _buildForm(
        context,
        isSubmitting: state is SignUpCreating,
      ),
    };
  }

  Widget _buildForm(BuildContext context, {required bool isSubmitting}) {
    final i18n = I18n.of(context);
    return EmailPasswordForm(
      labels: EmailPasswordFormLabels(
        email: i18n.translate('sign_up_feature.email_label'),
        password: i18n.translate('sign_up_feature.password_label'),
        submit: i18n.translate('sign_up_feature.submit_button_title'),
        submittingSemantics: i18n.translate(
          'sign_up_feature.creating_message_semantics',
        ),
      ),
      isSubmitting: isSubmitting,
      onSubmit: context.read<SignUpCubit>().signUp,
    );
  }
}
