import 'package:flutter/material.dart' hide Notification;
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notifications/notifications.dart';

typedef MMessenger = ScaffoldFeatureController<SnackBar, SnackBarClosedReason>;

extension MSnackBarExtensions on BuildContext {
  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();

  MMessenger showSnackBar(String message) {
    final colorScheme = MColorScheme.of(this);
    final textTheme = MTextTheme.of(this);
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: MText(
          message,
          style: textTheme.captionRegular,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  MMessenger showErrorSnackBar(String message) {
    final colorScheme = MColorScheme.of(this);
    final textTheme = MTextTheme.of(this);
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        content: MText(
          message,
          style: textTheme.captionRegular,
          color: colorScheme.onError,
        ),
      ),
    );
  }

  MMessenger showNotificationBanner(Notification notification) {
    final colors = MColorScheme.of(this);
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: NotificationSnackBarContent(notification: notification),
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 30),
        backgroundColor: colors.background,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(this).height - 270,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  // MMessenger showBroadcastError(dynamic exception) {
  //   return showErrorSnackBar(
  //     (exception as BroadcastException).maybeMap(
  //       orElse: () => '',
  //       message: (value) => value.message,
  //       networkError: (_) => MErrorMessages.networkError,
  //       serverError: (_) => MErrorMessages.serverError,
  //       timeOutError: (_) => MErrorMessages.timeOutError,
  //     ),
  //   );
  // }

  // MMessenger showNoteError(NoteException exception) {
  //   return showErrorSnackBar(
  //     exception.maybeMap(
  //       orElse: () => '',
  //       message: (value) => value.message,
  //       networkError: (_) => MErrorMessages.networkError,
  //       serverError: (_) => MErrorMessages.serverError,
  //       timeOutError: (_) => MErrorMessages.timeOutError,
  //       unknownError: (_) => MErrorMessages.unknownError,
  //     ),
  //   );
  // }
}
