import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

final class InteractionManager {
  BuildContext? _context;

  void setContext(BuildContext context) => _context = context;

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
}
