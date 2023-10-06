import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

extension MDialogX on BuildContext {
  Future<void> showLoadingDialog() {
    return showDialog(
      context: this,
      builder: (context) => const MLoadingIndicator.box(),
    );
  }
}
