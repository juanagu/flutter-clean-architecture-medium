import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/validators/email_password_validator.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:flutter/material.dart';

class EmailPasswordFormLabels {
  const EmailPasswordFormLabels({
    required this.email,
    required this.password,
    required this.submit,
    required this.submittingSemantics,
  });

  final String email;
  final String password;
  final String submit;

  /// Read by screen readers while the form is submitting.
  final String submittingSemantics;
}

typedef EmailPasswordSubmit = void Function(String email, String password);

/// The email + password form shared by sign-in and sign-up. Owns its
/// controllers and validation, so a failed submit keeps what was typed; the
/// caller owns what happens on submit.
class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({
    super.key,
    required this.labels,
    required this.onSubmit,
    this.isSubmitting = false,
    this.footer,
  });

  final EmailPasswordFormLabels labels;
  final EmailPasswordSubmit onSubmit;

  /// While true the fields are read-only and the button shows progress.
  final bool isSubmitting;
  final Widget? footer;

  @override
  State<EmailPasswordForm> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  static const EmailPasswordValidator _validator = EmailPasswordValidator();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final footer = widget.footer;
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailField(context),
              _buildPasswordField(context),
              _buildSubmitButton(),
              ?footer,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: widget.labels.email),
      validator: (value) => _message(context, _validator.validateEmail(value)),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
      controller: _emailController,
      readOnly: widget.isSubmitting,
      autofocus: true,
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: widget.labels.password),
      obscureText: true,
      validator: (value) =>
          _message(context, _validator.validatePassword(value)),
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      readOnly: widget.isSubmitting,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(),
      autofillHints: const [AutofillHints.password],
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: FilledButton(
        onPressed: widget.isSubmitting ? null : _submit,
        child: widget.isSubmitting
            ? CircularIndicator(
                semanticsLabel: widget.labels.submittingSemantics,
              )
            : Text(widget.labels.submit),
      ),
    );
  }

  String? _message(BuildContext context, String? key) =>
      key == null ? null : I18n.of(context).translate(key);

  void _submit() {
    if (widget.isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    widget.onSubmit(_emailController.text.trim(), _passwordController.text);
  }
}
