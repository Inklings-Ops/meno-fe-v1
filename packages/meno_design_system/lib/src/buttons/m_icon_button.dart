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
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool isDisabled;

  const MIconButton({
    super.key,
    required this.icon,
    this.size = 24,
    this.iconSize,
    this.color,
    this.onPressed,
    this.isFilled = false,
    this.fillColor,
    this.padding,
    this.constraints,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final colors = MColorScheme.of(context)!;
    final VisualDensity visualDensity = theme.visualDensity;
    final double effectiveSize = theme.iconTheme.size ?? size;
    final BoxConstraints boxConstraints = visualDensity.effectiveConstraints(
      _kConstraints,
    );

    return InkResponse(
      radius: math.max(Material.defaultSplashRadius, (size)),
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
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
