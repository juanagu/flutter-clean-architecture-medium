import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/application/presentation/localizations/i18n.dart';
import 'package:app/src/features/sign_up/sign_up_feature.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatefulWidget {
  final FeatureConfig featureConfig;

  const SignUpButton({
    Key key,
    @required this.featureConfig,
  }) : super(key: key);
  @override
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  bool _isEnabled = false;
  @override
  void initState() {
    super.initState();
    _fetchIsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: FlatButton(
        child: Text(
          I18n.of(context).translate('sign_up_button_title'),
          style: Theme.of(context).textTheme.button.copyWith(
                decoration: TextDecoration.underline,
                color: Theme.of(context).accentColor,
              ),
        ),
        onPressed: () => SignUpFeature.navigate(context),
      ),
    );
  }

  Future<void> _fetchIsEnabled() async {
    var isEnabled = await widget.featureConfig.isEnabled(SignUpFeature.Key);
    if (isEnabled != _isEnabled) {
      setState(() {
        _isEnabled = isEnabled;
      });
    }
  }
}
