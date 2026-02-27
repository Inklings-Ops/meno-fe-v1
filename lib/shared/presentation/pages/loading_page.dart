import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: MLoadingIndicator.box()));
  }
}
