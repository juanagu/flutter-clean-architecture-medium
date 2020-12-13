import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_cubit.dart';
import 'package:app/src/features/sign_in/presentation/validators/sign_in_validator.dart';
import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:flutter/material.dart';
import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInComponent extends StatelessWidget {
  final SignInCubit cubit;
  final Function(BuildContext) onAuthorized;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInValidator _validator = SignInValidator();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInComponent({
    Key key,
    @required this.cubit,
    @required this.onAuthorized,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: _listenByState,
        builder: _buildByState,
      ),
    );
  }

  void _listenByState(
    BuildContext context,
    SignInState state,
  ) {
    state.maybeWhen(
        authorized: () => onAuthorized(context),
        unauthorized: () => _showUnauthorized(context),
        unexpectedError: () => _showUnexpectedError(context),
        orElse: () {});
  }

  Widget _buildByState(
    BuildContext context,
    SignInState state,
  ) {
    return state.maybeWhen(
      authenticating: () => _buildAuthenticating(context),
      authorized: () => _buildAuthorizedView(context),
      orElse: () => _buildSignInFormView(context),
    );
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
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
    if (_formKey.currentState.validate()) {
      cubit.signIn(
        _emailController.text.trimLeft().trimRight(),
        _passwordController.text,
      );
    }
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SignUpFeature().buildButton();
  }

  Widget _buildAuthenticating(BuildContext context) {
    return Center(
      child: CircularIndicator(
        semanticsValue: I18n.of(context)
            .translate('sign_in_authenticating_message_semantics'),
      ),
    );
  }

  Widget _buildAuthorizedView(BuildContext context) {
    return Center(
      child: Icon(Icons.check),
    );
  }

  void _showUnauthorized(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).translate('sign_in_unauthorized_message'),
        ),
      ),
    );
  }

  void _showUnexpectedError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).translate('sign_in_unexpected_message'),
        ),
      ),
    );
  }
}
