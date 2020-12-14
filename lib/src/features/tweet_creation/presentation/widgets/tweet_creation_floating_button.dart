import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:app/src/features/tweet_creation/tweet_creation_feature.dart';
import 'package:flutter/material.dart';

class TweetCreationFloatingButton extends StatefulWidget {
  final FeatureConfig featureConfig;
  const TweetCreationFloatingButton({
    Key key,
    @required this.featureConfig,
  }) : super(key: key);

  @override
  _TweetCreationFloatingButtonState createState() =>
      _TweetCreationFloatingButtonState();
}

class _TweetCreationFloatingButtonState
    extends State<TweetCreationFloatingButton> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchIsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled) return SizedBox.shrink();

    return FloatingActionButton(
      onPressed: () => TweetCreationFeature.navigate(context),
      child: Icon(Icons.add_comment),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Future<void> _fetchIsEnabled() async {
    var isEnabled =
        await widget.featureConfig.isEnabled(TweetCreationFeature.Key);
    if (isEnabled != _isEnabled) {
      setState(() {
        _isEnabled = isEnabled;
      });
    }
  }
}
