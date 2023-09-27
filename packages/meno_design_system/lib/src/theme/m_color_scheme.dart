import 'package:flutter/material.dart';

import 'm_color.dart';

class MColorScheme extends ThemeExtension<MColorScheme> {
  final Brightness? brightness;
  final Color? primary;
  final Color? onPrimary;
  final Color? primaryContainer;
  final Color? onPrimaryContainer;
  final Color? secondary;
  final Color? onSecondary;
  final Color? secondaryContainer;
  final Color? onSecondaryContainer;
  final Color? tertiary;
  final Color? onTertiary;
  final Color? tertiaryContainer;
  final Color? onTertiaryContainer;
  final Color? error;
  final Color? onError;
  final Color? errorContainer;
  final Color? onErrorContainer;
  final Color? background;
  final Color? onBackground;
  final Color? surface;
  final Color? onSurface;
  final Color? surfaceTint;
  final Color? inverseSurface;
  final Color? onInverseSurface;
  final Color? inversePrimary;
  final Color? outline;
  final Color? outlineVariant;
  final Color? scrim;
  final Color? shadow;

  MColorScheme({
    this.brightness,
    this.primary,
    this.onPrimary,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.secondary,
    this.onSecondary,
    this.secondaryContainer,
    this.onSecondaryContainer,
    this.tertiary,
    this.onTertiary,
    this.tertiaryContainer,
    this.onTertiaryContainer,
    this.error,
    this.onError,
    this.errorContainer,
    this.onErrorContainer,
    this.background,
    this.onBackground,
    this.surface,
    this.onSurface,
    this.surfaceTint,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.outline,
    this.outlineVariant,
    this.scrim,
    this.shadow,
  });

  static T resolve<T>(bool isLight, T lightSchemeValue, T darkSchemeValue) {
    return isLight ? lightSchemeValue : darkSchemeValue;
  }

  factory MColorScheme.$default(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return MColorScheme(
      brightness: brightness,
      primary: resolve(isLight, MColor.primary300, MColor.primary75),
      onPrimary: resolve(isLight, MColor.white, MColor.primary700),
      primaryContainer: resolve(isLight, MColor.white, MColor.primary50),
      onPrimaryContainer:
          resolve(isLight, MColor.primary600, MColor.primary600),
      secondary: resolve(isLight, MColor.secondary300, MColor.secondary75),
      onSecondary: resolve(isLight, MColor.white, MColor.secondary600),
      secondaryContainer:
          resolve(isLight, MColor.secondary50, MColor.secondary50),
      onSecondaryContainer:
          resolve(isLight, MColor.secondary600, MColor.secondary600),
      tertiary: resolve(
          isLight, MColor.decorativeYellow200, MColor.decorativeYellow200),
      onTertiary: resolve(isLight, MColor.black, MColor.black),
      tertiaryContainer: resolve(
          isLight, MColor.decorativeYellow50, MColor.decorativeYellow50),
      onTertiaryContainer: resolve(isLight, MColor.black, MColor.black),
      error: resolve(isLight, MColor.error300, MColor.error75),
      onError: resolve(isLight, MColor.white, MColor.error600),
      errorContainer: resolve(isLight, MColor.error50, MColor.error500),
      onErrorContainer: resolve(isLight, MColor.error600, MColor.error50),
      background: resolve(isLight, MColor.white, MColor.primary700),
      onBackground: resolve(isLight, MColor.black, MColor.white),
      surface: resolve(isLight, MColor.white, MColor.primary700),
      onSurface: resolve(isLight, MColor.black, MColor.white),
      surfaceTint: resolve(isLight, MColor.grey20, MColor.primaryAlt),
      inverseSurface: resolve(isLight, MColor.primary600, MColor.primary75),
      onInverseSurface: resolve(isLight, MColor.white, MColor.primary600),
      inversePrimary: resolve(isLight, MColor.primary75, MColor.primary200),
      outline: resolve(isLight, MColor.primary300, MColor.primary75),
      outlineVariant: resolve(isLight, MColor.grey30, MColor.grey400),
      scrim: resolve(isLight, MColor.n0, MColor.n0),
      shadow: const Color.fromRGBO(54, 0, 144, 0.3),
    );
  }

  @override
  ThemeExtension<MColorScheme> copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceTint,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? outline,
    Color? outlineVariant,
    Color? scrim,
    Color? shadow,
  }) {
    return MColorScheme(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      scrim: scrim ?? this.scrim,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ThemeExtension<MColorScheme> lerp(
    covariant ThemeExtension<MColorScheme>? other,
    double t,
  ) {
    if (other is! MColorScheme) return this;
    return MColorScheme(
      brightness: other.brightness,
      primary: Color.lerp(primary, other.primary, t),
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t),
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t),
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t),
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t),
      onSecondaryContainer:
          Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t),
      tertiary: Color.lerp(tertiary, other.tertiary, t),
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t),
      tertiaryContainer:
          Color.lerp(tertiaryContainer, other.tertiaryContainer, t),
      onTertiaryContainer:
          Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t),
      error: Color.lerp(error, other.error, t),
      onError: Color.lerp(onError, other.onError, t),
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t),
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t),
      background: Color.lerp(background, other.background, t),
      onBackground: Color.lerp(onBackground, other.onBackground, t),
      surface: Color.lerp(surface, other.surface, t),
      onSurface: Color.lerp(onSurface, other.onSurface, t),
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t),
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t),
      onInverseSurface: Color.lerp(onInverseSurface, other.onInverseSurface, t),
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t),
      outline: Color.lerp(outline, other.outline, t),
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t),
      scrim: Color.lerp(scrim, other.scrim, t),
      shadow: Color.lerp(shadow, other.shadow, t),
    );
  }
}
