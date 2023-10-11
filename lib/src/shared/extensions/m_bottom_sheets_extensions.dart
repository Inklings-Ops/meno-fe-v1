import 'package:flutter/material.dart';

import '../modals/m_switch_account_modal.dart';

extension MBottomSheetsX on BuildContext {
  Future showSwitchAccountSheet() {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      builder: (context) => const MSwitchAccountModal(),
    );
  }
}
