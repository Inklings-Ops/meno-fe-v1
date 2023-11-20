import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _kMinSize = 24;
const BoxConstraints _kConstraints = BoxConstraints(
  minWidth: _kMinSize,
  minHeight: _kMinSize,
);

class MIconButton extends StatelessWidget {
  final Widget icon;
  final double size;
  final double? iconSize;
  final Color? color;
  final Color? fillColor;
  final bool isFilled;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;

  const MIconButton({
    super.key,
    required this.icon,
    this.size = 24,
    this.iconSize,
    this.color,
    this.onPressed,
    this.isFilled = false,
    this.fillColor,
    this.padding = const EdgeInsets.all(8),
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VisualDensity visualDensity = theme.visualDensity;
    final double effectiveSize = theme.iconTheme.size ?? size;
    final BoxConstraints boxConstraints = visualDensity.effectiveConstraints(
      _kConstraints,
    );

    return InkResponse(
      radius: math.max(Material.defaultSplashRadius, (size)),
      onTap: onPressed,
      child: Container(
        constraints: constraints ?? boxConstraints,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFilled ? fillColor : null,
        ),
        padding: isFilled ? padding : EdgeInsets.zero,
        child: SizedBox.square(
          dimension: effectiveSize,
          child: IconTheme.merge(
            data: IconThemeData(
              size: iconSize ?? effectiveSize,
              color: color ?? theme.iconTheme.color,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
