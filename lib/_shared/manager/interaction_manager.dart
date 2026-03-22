import 'package:flutter/material.dart';
import 'package:meno/features/notifications/widgets/notification_toast_stack.dart';
import 'package:meno_design_system/meno_design_system.dart';

final class InteractionManager {
  BuildContext? _context;
  OverlayEntry? _toastOverlayEntry;

  void setContext(BuildContext context) {
    _context = context;
    _ensureToastOverlay();
  }

  BuildContext get stableContext {
    final ctx = _context;
    if (ctx != null && ctx.mounted) return ctx;
    throw Exception('No build context found');
  }

  MColorScheme get _colorScheme => MColorScheme.of(stableContext);

  MTextTheme get _textTheme => MTextTheme.of(stableContext);

  void clearSnackBars() => ScaffoldMessenger.of(stableContext).clearSnackBars();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(stableContext).showSnackBar(
      SnackBar(
        backgroundColor: _colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: MText(
          message,
          style: _textTheme.captionRegular,
          color: _colorScheme.onPrimary,
        ),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(stableContext).showSnackBar(
      SnackBar(
        backgroundColor: _colorScheme.error,
        behavior: SnackBarBehavior.floating,
        content: MText(
          message,
          style: _textTheme.captionRegular,
          color: _colorScheme.onError,
        ),
      ),
    );
  }

  void _ensureToastOverlay() {
    // Already inserted — nothing to do
    if (_toastOverlayEntry != null) return;

    final overlay = Overlay.maybeOf(stableContext);
    if (overlay == null) return;

    _toastOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 8,
        left: 16,
        right: 16,
        child: const NotificationToastStack(),
      ),
    );

    // Schedule insertion after the current frame — overlay must be mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_toastOverlayEntry != null) {
        overlay.insert(_toastOverlayEntry!);
      }
    });
  }

  void removeToastOverlay() {
    _toastOverlayEntry?.remove();
    _toastOverlayEntry = null;
  }
}
