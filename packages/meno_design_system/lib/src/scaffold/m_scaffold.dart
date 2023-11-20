import 'package:flutter/material.dart';

class MScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final bool? resizeToAvoidBottomInset;

  const MScaffold({
    super.key,
    this.appBar,
    this.body,
    this.padding,
    this.scrollController,
    this.resizeToAvoidBottomInset,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: body,
        ),
      );
}
