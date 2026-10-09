import 'package:app/src/application/localizations/i18n.dart';
import 'package:app/src/application/theme/tokens.dart';
import 'package:app/src/application/validators/email_password_validator.dart';
import 'package:app/src/application/widgets/forms/email_password_form_labels.dart';
import 'package:app/src/application/widgets/forms/form_error_message.dart';
import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:flutter/material.dart';

export 'package:app/src/application/widgets/forms/email_password_form_labels.dart';

typedef EmailPasswordSubmit = void Function(String email, String password);

/// The email + password form shared by sign-in and sign-up: heading, two
/// fields, an optional inline error, the submit button and a footer. Owns
/// its controllers and validation, so a failed submit keeps what was typed;
/// the caller owns what happens on submit.
class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({
    super.key,
    required this.labels,
    required this.onSubmit,
    this.isSubmitting = false,
    this.errorText,
    this.focusPasswordOnError = false,
    this.passwordHelperText,
    this.topSpacing = Space.s6,
    this.footer,
  });

  final EmailPasswordFormLabels labels;
  final EmailPasswordSubmit onSubmit;

  /// While true the fields are read-only and the button shows progress.
  final bool isSubmitting;

  /// A failure the user fixes by retyping, shown above the button.
  final String? errorText;

  /// Moves focus to the password when [errorText] appears.
  final bool focusPasswordOnError;
  final String? passwordHelperText;

  /// Gap between the top of the body and the heading.
  final double topSpacing;

  /// Rendered under the button; hidden while submitting, its height kept.
  final Widget? footer;

  @override
  State<EmailPasswordForm> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  static const EmailPasswordValidator _validator = EmailPasswordValidator();
  static const double _footerHeight = 44;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void didUpdateWidget(EmailPasswordForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final errorAppeared =
        widget.errorText != null && widget.errorText != oldWidget.errorText;
    if (errorAppeared && widget.focusPasswordOnError) {
      _passwordFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.errorText;
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: widget.topSpacing),
            Text(
              widget.labels.heading,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Space.s5),
            _buildEmailField(context),
            const SizedBox(height: Space.s4),
            _buildPasswordField(context),
            const SizedBox(height: Space.s5),
            if (errorText != null) ...[
              FormErrorMessage(message: errorText),
              const SizedBox(height: Space.s4),
            ],
            _buildSubmitButton(),
            ..._buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      decoration: _decoration(widget.labels.email),
      style: _inputStyle(context),
      validator: (value) => _message(context, _validator.validateEmail(value)),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
      controller: _emailController,
      focusNode: _emailFocusNode,
      readOnly: widget.isSubmitting,
      autofocus: true,
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      decoration: _decoration(
        widget.labels.password,
        helperText: widget.passwordHelperText,
        suffixIcon: _buildVisibilityToggle(context),
      ),
      style: _inputStyle(context),
      obscureText: !_isPasswordVisible,
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

  Widget _buildVisibilityToggle(BuildContext context) {
    final key = _isPasswordVisible
        ? 'form.hide_password'
        : 'form.show_password';
    return IconButton(
      icon: Icon(
        _isPasswordVisible
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
      tooltip: I18n.of(context).translate(key),
      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
    );
  }

  /// The button keeps its colour while submitting; the spinner says why it
  /// does nothing.
  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _submit,
      child: widget.isSubmitting
          ? CircularIndicator.inButton(
              semanticsLabel: widget.labels.submittingSemantics,
            )
          : Text(widget.labels.submit),
    );
  }

  List<Widget> _buildFooter() {
    final footer = widget.footer;
    if (footer == null) return const [];

    return [
      const SizedBox(height: Space.s4),
      if (widget.isSubmitting)
        const SizedBox(height: _footerHeight)
      else
        footer,
    ];
  }

  InputDecoration _decoration(
    String label, {
    String? helperText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      suffixIcon: suffixIcon,
      filled: widget.isSubmitting,
    );
  }

  TextStyle? _inputStyle(BuildContext context) {
    if (!widget.isSubmitting) return null;

    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  String? _message(BuildContext context, String? key) =>
      key == null ? null : I18n.of(context).translate(key);

  void _submit() {
    if (widget.isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      _focusFirstInvalidField();
      return;
    }

    widget.onSubmit(_emailController.text.trim(), _passwordController.text);
  }

  void _focusFirstInvalidField() {
    final emailIsValid =
        _validator.validateEmail(_emailController.text) == null;
    (emailIsValid ? _passwordFocusNode : _emailFocusNode).requestFocus();
  }
}
