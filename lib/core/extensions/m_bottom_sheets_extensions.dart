import 'package:flutter/material.dart';
import 'package:meno_fe_v1/shared/modals/m_switch_account_modal.dart';

extension MBottomSheetsX on BuildContext {
  Future showSwitchAccountSheet() {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      builder: (context) => const MSwitchAccountModal(),
    );
  }
}
