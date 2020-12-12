import 'package:app/src/features/sign_in/presentation/validators/sign_in_validator.dart';
import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:flutter/material.dart';
import 'package:app/src/core/presentation/localizations/i18n.dart';

class SignInComponent extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInValidator _validator = SignInValidator();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _buildSignInFormView(context);
  }

  Widget _buildSignInFormView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailTextField(context),
              _buildPasswordTextField(context),
              _buildSignInSubmitButton(context),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: I18n.of(context).translate('sign_in_email_label'),
      ),
      validator: (value) => _validator.validateEmail(context, value),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        _passwordFocusNode.requestFocus();
      },
      controller: _emailController,
      autofocus: true,
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: I18n.of(context).translate('sign_up_password_label'),
      ),
      obscureText: true,
      validator: (value) => _validator.validatePassword(context, value),
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.send,
      onFieldSubmitted: (_) {
        _onSubmit();
      },
    );
  }

  Widget _buildSignInSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: RaisedButton(
        child: Text(
          I18n.of(context).translate('sign_in_submit_button_title'),
        ),
        onPressed: _onSubmit,
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {}
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SignUpFeature().buildButton();
  }
}
