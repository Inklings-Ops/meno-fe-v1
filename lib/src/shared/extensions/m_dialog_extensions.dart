import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../features/broadcast/presentation/widgets/broadcast_exit_alert_dialog.dart';
import '../../features/chat/presentation/widgets/delete_comment_alert_dialog.dart';

extension MDialogX on BuildContext {
  Future<void> showLoadingDialog() {
    return showDialog(
      context: this,
      builder: (context) => const MLoadingIndicator.box(),
    );
  }

  Future<bool?> showEndBroadcastDialog() {
    return showDialog<bool>(
      context: this,
      builder: (context) => const BroadcastExitAlertDialog(),
    );
  }

  Future<bool?> showLeaveBroadcastDialog() {
    return showDialog<bool>(
      context: this,
      builder: (context) => const BroadcastExitAlertDialog(
        isBroadcasting: false,
      ),
    );
  }

  Future<bool?> showDeleteCommentDialog() {
    return showDialog<bool>(
      context: this,
      builder: (context) => const DeleteCommentAlertDialog(),
    );
  }
}
