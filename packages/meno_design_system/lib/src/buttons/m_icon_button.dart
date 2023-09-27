import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _kMinSize = 24;
const BoxConstraints _kConstraints = BoxConstraints(
  minWidth: _kMinSize,
  minHeight: _kMinSize,
);

class MIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onPressed;

  const MIconButton({
    super.key,
    required this.icon,
    this.size = 24,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final VisualDensity visualDensity = theme.visualDensity;
    final double effectiveSize = theme.iconTheme.size ?? size;
    final BoxConstraints constraints = visualDensity.effectiveConstraints(
      _kConstraints,
    );

    return InkResponse(
      radius: math.max(Material.defaultSplashRadius, (size)),
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: constraints,
        child: SizedBox.square(
          dimension: effectiveSize,
          child: IconTheme.merge(
            data: IconThemeData(
              size: effectiveSize,
              color: color ?? theme.iconTheme.color,
            ),
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
