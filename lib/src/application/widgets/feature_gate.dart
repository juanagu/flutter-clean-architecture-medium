import 'package:app/src/abstractions/features/feature_config.dart';
import 'package:flutter/material.dart';

typedef FeatureGateBuilder = Widget Function(
  BuildContext context,
  bool isEnabled,
);

/// Renders [child] only while the [flag] is on, or hands [builder] the
/// flag's value when the layout around a feature depends on it too. The
/// flag is read once when the gate mounts; a changed flag shows after the
/// screen is rebuilt.
class FeatureGate extends StatefulWidget {
  const FeatureGate({
    super.key,
    required this.featureConfig,
    required this.flag,
    required Widget this.child,
  }) : builder = null;

  const FeatureGate.builder({
    super.key,
    required this.featureConfig,
    required this.flag,
    required FeatureGateBuilder this.builder,
  }) : child = null;

  final FeatureConfig featureConfig;
  final String flag;
  final Widget? child;
  final FeatureGateBuilder? builder;

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
    final builder = widget.builder;
    if (builder != null) return builder(context, _isEnabled);
    if (!_isEnabled) return const SizedBox.shrink();

    return widget.child ?? const SizedBox.shrink();
  }

  Future<void> _fetchIsEnabled() async {
    final isEnabled = await widget.featureConfig.isEnabled(widget.flag);
    if (!mounted || isEnabled == _isEnabled) return;

    setState(() => _isEnabled = isEnabled);
  }
}
