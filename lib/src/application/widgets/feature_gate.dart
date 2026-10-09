import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:flutter/material.dart';

/// Renders [child] only while the [flag] is on. The flag is read once when
/// the gate mounts; a changed flag shows after the screen is rebuilt.
class FeatureGate extends StatefulWidget {
  const FeatureGate({
    super.key,
    required this.featureConfig,
    required this.flag,
    required this.child,
  });

  final FeatureConfig featureConfig;
  final String flag;
  final Widget child;

  @override
  State<FeatureGate> createState() => _FeatureGateState();
}

class _FeatureGateState extends State<FeatureGate> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchIsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled) return const SizedBox.shrink();

    return widget.child;
  }

  Future<void> _fetchIsEnabled() async {
    final isEnabled = await widget.featureConfig.isEnabled(widget.flag);
    if (!mounted || isEnabled == _isEnabled) return;

    setState(() => _isEnabled = isEnabled);
  }
}
