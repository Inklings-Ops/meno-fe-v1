import 'package:meno_fe_v1/meno.dart';

extension MBottomSheetsX on BuildContext {
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

  Future<T?> showSwitchAccountSheet<T>() => showModal(
        const MSwitchAccountModal(),
        isScrollControlled: true,
        useRootNavigator: true,
      );
}
