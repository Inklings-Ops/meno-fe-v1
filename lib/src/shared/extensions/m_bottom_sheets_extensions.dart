import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/widgets/stream/pre_stream_modal.dart';
import 'package:meno_fe_v1/src/shared/modals/m_switch_account_modal.dart';

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
      backgroundColor: MColorScheme.of(this)?.background,
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

  Future<dynamic> showJoinLiveBroadcastModal(Broadcast broadcast) async {
    return showModal(
      isScrollControlled: true,
      useRootNavigator: true,
      PreStreamModal(broadcast: broadcast),
    );
  }
}
