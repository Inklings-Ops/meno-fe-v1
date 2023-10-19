import 'package:flutter/material.dart';

class MScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  const MScaffold({
    super.key,
    this.appBar,
    this.body,
    this.padding,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        body: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: body,
        ),
      );
}
