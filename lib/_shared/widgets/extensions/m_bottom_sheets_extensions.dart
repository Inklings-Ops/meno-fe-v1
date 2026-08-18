import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

extension MenoBottomSheetsX on BuildContext {
  Future<T?> showModal<T>(
    Widget child, {
    BoxConstraints? constraints,
    bool? isScrollControlled,
    bool? useRootNavigator,
    bool? isDismissible,
    bool? enableDrag,
  }) {
    return showModalBottomSheet<T?>(
      context: this,
      builder: (context) => Material(child: child),
      constraints: constraints,
      backgroundColor: MColorScheme.of(this).background,
      isScrollControlled: isScrollControlled ?? false,
      useRootNavigator: useRootNavigator ?? false,
      isDismissible: isDismissible ?? true,
      enableDrag: enableDrag ?? true,
      showDragHandle: true,
      useSafeArea: true,
    );
  }
}
