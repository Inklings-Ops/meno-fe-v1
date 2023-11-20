import 'package:flutter/material.dart';

import '../modals/m_switch_account_modal.dart';

extension MBottomSheetsX on BuildContext {
  Future showModal(
    Widget child, {
    BoxConstraints? constraints,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet(
      context: this,
      builder: (context) => child,
      constraints: constraints,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: true,
    );
  }

  Future showSwitchAccountSheet() =>
      showModal(const MSwitchAccountModal(), isScrollControlled: true);



}
