import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

typedef MMessenger = ScaffoldFeatureController<SnackBar, SnackBarClosedReason>;

extension MContextX on BuildContext {
  MMessenger showErrorSnackBar(String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: MText(
          message,
          style: MTextStyle.captionRegular,
          color: MColorScheme.of(this)?.onError,
        ),
      ),
    );
  }

  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();
}
