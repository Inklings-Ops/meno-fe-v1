import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

/// {@template meno_tab_bar_theme}
/// Custom implementation of theme configurations for [MTabBar]
/// {@endtemplate}
class MTabBarTheme extends ThemeExtension<MTabBarTheme> {
  /// {@macro meno_tab_bar_theme}
  const MTabBarTheme({
    required this.normal,
    required this.contained,
    required this.padding,
    required this.labelPadding,
    required this.height,
  });

  /// Snackbar theme
  factory MTabBarTheme.of(BuildContext context) {
    return Theme.of(context).extension<MTabBarTheme>()!;
  }

  /// {@macro meno_tab_bar_theme}
  factory MTabBarTheme.$default(MColorScheme colors) {
    final iconTheme = IconThemeData(
      size: 15.sp,
      color: colors.disabledContainer,
    );
    return MTabBarTheme(
      normal: TabBarStyle(
        labelColor: MInternal.resolveWith(
          defaultValue: colors.inActive,
          selectedValue: colors.primary,
        ),
        backgroundColor: MInternal.all(Colors.transparent),
        dividerColor: colors.inActive,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colors.primary),
        ),
        dividerHeight: 1.h,
        iconTheme: MInternal.resolveWith(
          defaultValue: iconTheme,
          selectedValue: iconTheme.copyWith(color: colors.secondaryContainer),
        ),
      ),
      contained: TabBarStyle(
        labelColor: MInternal.resolveWith(
          defaultValue: colors.disabledContainer,
          selectedValue: colors.primary,
        ),
        backgroundColor: MInternal.resolveWith(
          defaultValue: colors.secondary,
          selectedValue: colors.primary,
        ),
        dividerColor: Colors.transparent,
        indicator: const BoxDecoration(),
        dividerHeight: 0,
        iconTheme: MInternal.resolveWith(
          defaultValue: iconTheme,
          selectedValue: iconTheme.copyWith(color: colors.primary),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg).r,
      labelPadding: const EdgeInsets.fromLTRB(16, 6, 16, 6).r,
      height: 32.h,
    );
  }

  /// [TabBarStyle]s for the [MTabBar.normal] tab bar
  final TabBarStyle normal;

  /// [TabBarStyle]s for the [MTabBar.contained] tab bar
  final TabBarStyle contained;

  /// Padding given to the [MTabBar]
  final EdgeInsetsGeometry padding;

  /// Padding for the individual [MenoTab] labels
  final EdgeInsetsGeometry labelPadding;

  /// Height of the [MTabBar]
  final double height;

  @override
  MTabBarTheme copyWith({
    TabBarStyle? normal,
    TabBarStyle? contained,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? labelPadding,
    double? height,
  }) {
    return MTabBarTheme(
      normal: normal ?? this.normal,
      contained: contained ?? this.contained,
      padding: padding ?? this.padding,
      labelPadding: labelPadding ?? this.labelPadding,
      height: height ?? this.height,
    );
  }

  @override
  ThemeExtension<MTabBarTheme> lerp(
    covariant ThemeExtension<MTabBarTheme>? other,
    double t,
  ) {
    if (other is! MTabBarTheme) return this;
    return MTabBarTheme(
      normal: TabBarStyle.lerp(normal, other.normal, t)!,
      contained: TabBarStyle.lerp(contained, other.contained, t)!,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t)!,
      labelPadding: EdgeInsetsGeometry.lerp(
        labelPadding,
        other.labelPadding,
        t,
      )!,
      height: lerpDouble(height, other.height, t)!,
    );
  }
}
