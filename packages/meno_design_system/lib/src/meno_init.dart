import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

Styles $styles = Styles.configure();

class MenoInit extends StatelessWidget {
  const MenoInit({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    $styles = Styles.configure(context: context);
    return MediaQuery(
      data: mq,
      child: KeyedSubtree(
        key: ValueKey($styles.scale),
        child: Theme(
          data: MTheme.theme(mq.platformBrightness),
          child: DefaultTextStyle(
            style: $styles.text.bodyRegular,
            child: child,
          ),
        ),
      ),
    );
  }
}



// class MenoInit extends StatelessWidget {
//   const MenoInit({super.key, required this.child, required this.configureSize});
//   final Widget child;
//   final ValueChanged<Size> configureSize;

//   static Styles _style = Styles.configure();
//   static Styles get style => _style;

//   @override
//   Widget build(BuildContext context) {
// final size = MediaQuery.sizeOf(context);
//   configureSize.call(size);
//   _style =Styles.configure(context: context);
//       return KeyedSubtree(
//       key: ValueKey($styles.scale),
//       child: Theme(
//         data: MTheme.theme(MediaQuery.platformBrightnessOf(context)),
//         child: DefaultTextStyle(
//           style: $styles.text.bodyRegular,
//           child: child,
//         ),
//       ),
//     );

//   }
// }

