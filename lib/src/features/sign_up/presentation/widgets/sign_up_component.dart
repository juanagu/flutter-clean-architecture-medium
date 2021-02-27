import 'package:app/src/application/widgets/indicators/circular_indicator.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_cubit.dart';
import 'package:app/src/features/sign_up/presentation/validators/sign_up_validator.dart';
import 'package:flutter/material.dart';
import 'package:app/src/application/localizations/i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpComponent extends StatelessWidget {
  SignUpComponent({
    Key key,
    @required this.cubit,
    @required this.onRegistered,
  }) : super(key: key);

  final SignUpCubit cubit;
  final Function(BuildContext) onRegistered;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpValidator _validator = SignUpValidator();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: _listenByState,
        builder: _buildByState,
      ),
    );
  }

  void _listenByState(
    BuildContext context,
    SignUpState state,
  ) {
    state.maybeWhen(
        registered: () => onRegistered(context),
        emailAlreadyInUse: () => _showEmailAlreadyInUse(context),
        unexpectedError: () => _showUnexpectedError(context),
        orElse: () {});
  }

  Widget _buildByState(
    BuildContext context,
    SignUpState state,
  ) {
    return state.maybeWhen(
      creating: () => _buildCreatingView(context),
      registered: () => _buildRegisteredView(context),
      orElse: () => _buildSignUpFormView(context),
    );
  }

  Widget _buildSignUpFormView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildEmailTextField(context),
              _buildPasswordTextField(context),
              _buildSignInSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: I18n.of(context).translate('sign_up_feature.email_label'),
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
        labelText: I18n.of(context).translate('sign_up_feature.password_label'),
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
          I18n.of(context).translate('sign_up_feature.submit_button_title'),
        ),
        onPressed: _onSubmit,
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      cubit.signUp(
        _emailController.text.trimRight().trimLeft(),
        _passwordController.text,
      );
    }
  }

  Widget _buildCreatingView(BuildContext context) {
    return Center(
      child: CircularIndicator(
        semanticsValue: I18n.of(context)
            .translate('sign_up_feature.creating_message_semantics'),
      ),
    );
  }

  Widget _buildRegisteredView(BuildContext context) {
    return const Center(child: Icon(Icons.check));
  }

  void _showEmailAlreadyInUse(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).translate('sign_up_feature.email_already_in_use'),
        ),
      ),
    );
  }

  void _showUnexpectedError(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          I18n.of(context).translate('sign_up_feature.unexpected_message'),
        ),
      ),
    );
  }
}
