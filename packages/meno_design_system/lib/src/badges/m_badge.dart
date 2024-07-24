import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';
import 'package:meno_design_system/src/m_internal.dart';

class MBadge extends StatelessWidget {
  final MColor? color;
  final String? value;
  final String? viewCount;
  final TextStyle? textStyle;
  final MColor? valueColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final bool showLoader;
  final bool showBorder;

  MBadge.cohost({Key? key})
      : this._(
          key: key,
          value: "Co-host",
          height: 20.0,
          width: 60.0,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MColor.grey30,
          valueColor: MColor.primary700,
          textStyle: $styles.text.microMedium,
        );

  MBadge.host({Key? key})
      : this._(
          key: key,
          value: "Host",
          constraints: const BoxConstraints(minHeight: 20.0, maxWidth: 59.0),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MColor.grey30,
          valueColor: MColor.primary700,
          textStyle: $styles.text.microMedium,
        );

  const MBadge.large({Key? key, required String value})
      : this._(
          key: key,
          value: value,
          // padding: const EdgeInsets.fromLTRB(4.5, 2, 4.5, 2),
          constraints: const BoxConstraints(minHeight: 16.0, minWidth: 16.0),
        );

  const MBadge.live({
    Key? key,
    String? count,
    bool showLoader = false,
    bool showBorder = false,
  }) : this._(
          key: key,
          value: "LIVE",
          viewCount: count,
          height: 18,
          showLoader: showLoader,
          constraints: const BoxConstraints(minHeight: 18.0),
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          showBorder: showBorder,
        );

  MBadge.offAir(BuildContext context, {Key? key})
      : this._(
          key: key,
          value: "OFF-AIR",
          height: 18,
          constraints: const BoxConstraints(minHeight: 18.0),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          color: MColorScheme.of(context)?.disabledContainer,
          valueColor: MColorScheme.of(context)?.onDisabled,
        );

  MBadge.reconnecting(BuildContext context, {Key? key})
      : this._(
          key: key,
          value: "RECONNECTING",
          height: 18,
          constraints: const BoxConstraints(minHeight: 18.0),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          color: MColorScheme.of(context)?.errorContainer,
          valueColor: MColorScheme.of(context)?.onError,
        );

  MBadge.newBadge(BuildContext context, {Key? key})
      : this._(
          key: key,
          value: "NEW",
          constraints: const BoxConstraints(minHeight: 16.0),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          valueColor: MColorScheme.of(context)?.primary,
          color: MInternal.resolve(
            Theme.of(context).brightness == Brightness.light,
            MColor.newBadgeLight,
            MColor.newBadgeDark,
          ),
        );

  const MBadge.small({Key? key})
      : this._(
          key: key,
          height: 6.0,
          width: 6.0,
          constraints: const BoxConstraints(minHeight: 6.0, minWidth: 6.0),
        );

  const MBadge._({
    Key? key,
    this.color,
    this.value,
    this.viewCount,
    this.textStyle,
    this.valueColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(556)),
    this.height,
    this.width,
    this.padding,
    this.constraints,
    this.showLoader = false,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    Widget? child;

    if (value != null) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLoader)
            Assets.images.loading.image(color: valueColor ?? colors.onError),
          _buildText(value!, colors),
          if (viewCount != null) ...[
            6.hSpace,
            _buildText(viewCount!, colors),
          ],
        ],
      );
    }

    return Container(
      height: height?.toScale,
      width: width?.toScale,
      padding: padding?.radius,
      constraints: constraints?.radius,
      decoration: ShapeDecoration(
        color: color ?? colors.error,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius?.radius ?? BorderRadius.zero,
          side: showBorder
              ? BorderSide(width: 1.toScale, color: valueColor ?? Colors.white)
              : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  MText _buildText(String content, MColorScheme colors) {
    return MText(
      content,
      textAlign: TextAlign.center,
      style: textStyle?.copyWith(letterSpacing: 0.5.toScale),
      color: valueColor ?? colors.onError,
    );
  }
}
