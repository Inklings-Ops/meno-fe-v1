import 'package:flutter/material.dart';

class MScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry? padding;
  // final bool isScrollable;
  final ScrollController? scrollController;

  const MScaffold({
    super.key,
    this.appBar,
    this.body,
    this.padding,
    // this.isScrollable = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        body: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          // physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
          // controller: scrollController,
          child: body,
        ),
      );
}
