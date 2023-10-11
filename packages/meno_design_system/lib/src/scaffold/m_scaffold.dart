import 'package:flutter/material.dart';

class MScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;

  const MScaffold({
    super.key,
    this.appBar,
    this.body,
    this.padding,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
          child: body,
        ),
      );
}
