import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

Styles $styles = MenoInit.style;

class MenoInit extends StatelessWidget {
  static Styles _style = Styles();
  static Styles get style => _style;

  const MenoInit({super.key, required this.child, this.configureSize});
  final Widget child;
  final ValueChanged<Size>? configureSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final brightness = MediaQuery.platformBrightnessOf(context);
    configureSize?.call(size);
    _style = Styles(context: context);
    return KeyedSubtree(
      key: ValueKey($styles.scale),
      child: Theme(
        data: MTheme.theme(brightness),
        child: DefaultTextStyle(
          style: $styles.text.bodyRegular,
          child: child,
        ),
      ),
    );
  }
}
