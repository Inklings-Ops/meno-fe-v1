import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MScaffold extends StatelessWidget {
  const MScaffold({
    super.key,
    this.appBar,
    this.body,
    this.padding,
    this.scrollController,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar,
    this.persistentFooterButtons,
  });
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final List<Widget>? persistentFooterButtons;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16).radius,
          child: body,
        ),
        bottomNavigationBar: bottomNavigationBar,
        persistentFooterButtons: persistentFooterButtons,
      );
}
