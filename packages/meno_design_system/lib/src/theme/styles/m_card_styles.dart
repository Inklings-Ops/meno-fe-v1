import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

class MCardStyles extends ThemeExtension<MCardStyles> {
  final MColor? backgroundColor;
  final MColor? titleColor;
  final MColor? hostColor;

  final MTextStyle? titleStyle;
  final MTextStyle? hostStyle;

  MCardStyles({
    this.backgroundColor,
    this.titleColor,
    this.hostColor,
    this.titleStyle,
    this.hostStyle,
  });

  static T _resolve<T>(isLight, a, b) => MInternal.resolve(isLight, a, b);

  factory MCardStyles.$default({required MColorScheme colorScheme}) {
    final isLight = colorScheme.brightness == Brightness.light;
    return MCardStyles(
      backgroundColor: _resolve(isLight, MColor.white, MColor.primaryAlt),
      titleColor: colorScheme.onBackground,
      hostColor: _resolve(isLight, MColor.grey80, MColor.grey30),
      titleStyle: MTextStyle.captionMedium,
      hostStyle: MTextStyle.captionRegular,
    );
  }

  @override
  ThemeExtension<MCardStyles> copyWith({
    MColor? backgroundColor,
    MColor? titleColor,
    MColor? hostColor,
    MTextStyle? titleStyle,
    MTextStyle? hostStyle,
  }) {
    return MCardStyles(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      hostColor: hostColor ?? this.hostColor,
      titleStyle: titleStyle ?? this.titleStyle,
      hostStyle: hostStyle ?? this.hostStyle,
    );
  }

  @override
  ThemeExtension<MCardStyles> lerp(MCardStyles? other, double t) {
    if (other is! MCardStyles) return this;
    return MCardStyles(
      backgroundColor: MColor.lerp(backgroundColor, other.backgroundColor, t),
      titleColor: MColor.lerp(titleColor, other.titleColor, t),
      hostColor: MColor.lerp(hostColor, other.hostColor, t),
      titleStyle: MTextStyle.lerp(titleStyle, other.titleStyle, t),
      hostStyle: MTextStyle.lerp(hostStyle, other.hostStyle, t),
    );
  }

  static MCardStyles? of(BuildContext context) {
    return Theme.of(context).extension<MCardStyles>();
  }
}
