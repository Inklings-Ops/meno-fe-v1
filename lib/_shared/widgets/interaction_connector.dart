import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_shared/manager/interaction_manager.dart';

/// Place this as the root child inside [MaterialApp.builder].
/// It keeps [InteractionManager] supplied with a valid, mounted context
/// that sits below the [ScaffoldMessenger] — so snack bars always work.
class InteractionConnector extends StatefulWidget {
  const InteractionConnector({required this.child, super.key});

  final Widget? child;

  @override
  State<InteractionConnector> createState() => _InteractionConnectorState();
}

class _InteractionConnectorState extends State<InteractionConnector> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    di<InteractionManager>().setContext(context);
  }

  @override
  Widget build(BuildContext context) => widget.child ?? const SizedBox.shrink();
}
