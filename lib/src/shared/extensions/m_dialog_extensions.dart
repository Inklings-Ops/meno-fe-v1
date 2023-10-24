import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

extension MDialogX on BuildContext {
  Future<bool?> showEndBroadcastAlert() {
    final MColorScheme colorScheme = MColorScheme.of(this)!;
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: const MText(
          "End Broadcast",
          style: MTextStyle.heading2Regular,
        ),
        contentPadding: const EdgeInsets.all(24),
        content: const MText(
          "Do you want to end this live broadcast?",
          style: MTextStyle.captionRegular,
        ),
        actions: [
          MTextButton(
            label: "Cancel",
            onPressed: () => context.popRoute(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onDisabled?.withOpacity(0.5),
              fixedSize: const Size.fromHeight(40),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          MDangerButton(
            label: "End Broadcast",
            onPressed: () => context.popRoute(true),
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              fixedSize: const Size.fromHeight(40),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showLoadingDialog() {
    return showDialog(
      context: this,
      builder: (context) => const MLoadingIndicator.box(),
    );
  }
}
