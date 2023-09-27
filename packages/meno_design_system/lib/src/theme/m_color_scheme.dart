import 'package:flutter/material.dart';

import 'm_color.dart';

class MColorScheme extends ThemeExtension<MColorScheme> {
  final Brightness? brightness;
  final MColor? primary;
  final MColor? onPrimary;
  final MColor? primaryContainer;
  final MColor? onPrimaryContainer;
  final MColor? secondary;
  final MColor? onSecondary;
  final MColor? secondaryContainer;
  final MColor? onSecondaryContainer;
  final MColor? tertiary;
  final MColor? onTertiary;
  final MColor? tertiaryContainer;
  final MColor? onTertiaryContainer;
  final MColor? error;
  final MColor? onError;
  final MColor? errorContainer;
  final MColor? onErrorContainer;
  final MColor? background;
  final MColor? onBackground;
  final MColor? surface;
  final MColor? onSurface;
  final MColor? surfaceTint;
  final MColor? inverseSurface;
  final MColor? onInverseSurface;
  final MColor? inversePrimary;
  final MColor? outline;
  final MColor? outlineVariant;
  final MColor? scrim;
  final MColor? shadow;

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
      shadow: MColor.shadow,
    );
  }

  @override
  ThemeExtension<MColorScheme> copyWith({
    Brightness? brightness,
    MColor? primary,
    MColor? onPrimary,
    MColor? primaryContainer,
    MColor? onPrimaryContainer,
    MColor? secondary,
    MColor? onSecondary,
    MColor? secondaryContainer,
    MColor? onSecondaryContainer,
    MColor? tertiary,
    MColor? onTertiary,
    MColor? tertiaryContainer,
    MColor? onTertiaryContainer,
    MColor? error,
    MColor? onError,
    MColor? errorContainer,
    MColor? onErrorContainer,
    MColor? background,
    MColor? onBackground,
    MColor? surface,
    MColor? onSurface,
    MColor? surfaceTint,
    MColor? inverseSurface,
    MColor? onInverseSurface,
    MColor? inversePrimary,
    MColor? outline,
    MColor? outlineVariant,
    MColor? scrim,
    MColor? shadow,
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
      primary: MColor.lerp(primary, other.primary, t),
      onPrimary: MColor.lerp(onPrimary, other.onPrimary, t),
      primaryContainer:
          MColor.lerp(primaryContainer, other.primaryContainer, t),
      onPrimaryContainer:
          MColor.lerp(onPrimaryContainer, other.onPrimaryContainer, t),
      secondary: MColor.lerp(secondary, other.secondary, t),
      onSecondary: MColor.lerp(onSecondary, other.onSecondary, t),
      secondaryContainer:
          MColor.lerp(secondaryContainer, other.secondaryContainer, t),
      onSecondaryContainer:
          MColor.lerp(onSecondaryContainer, other.onSecondaryContainer, t),
      tertiary: MColor.lerp(tertiary, other.tertiary, t),
      onTertiary: MColor.lerp(onTertiary, other.onTertiary, t),
      tertiaryContainer:
          MColor.lerp(tertiaryContainer, other.tertiaryContainer, t),
      onTertiaryContainer:
          MColor.lerp(onTertiaryContainer, other.onTertiaryContainer, t),
      error: MColor.lerp(error, other.error, t),
      onError: MColor.lerp(onError, other.onError, t),
      errorContainer: MColor.lerp(errorContainer, other.errorContainer, t),
      onErrorContainer:
          MColor.lerp(onErrorContainer, other.onErrorContainer, t),
      background: MColor.lerp(background, other.background, t),
      onBackground: MColor.lerp(onBackground, other.onBackground, t),
      surface: MColor.lerp(surface, other.surface, t),
      onSurface: MColor.lerp(onSurface, other.onSurface, t),
      surfaceTint: MColor.lerp(surfaceTint, other.surfaceTint, t),
      inverseSurface: MColor.lerp(inverseSurface, other.inverseSurface, t),
      onInverseSurface:
          MColor.lerp(onInverseSurface, other.onInverseSurface, t),
      inversePrimary: MColor.lerp(inversePrimary, other.inversePrimary, t),
      outline: MColor.lerp(outline, other.outline, t),
      outlineVariant: MColor.lerp(outlineVariant, other.outlineVariant, t),
      scrim: MColor.lerp(scrim, other.scrim, t),
      shadow: MColor.lerp(shadow, other.shadow, t),
    );
  }

  static MColorScheme? of(BuildContext context) {
    return Theme.of(context).extension<MColorScheme>();
  }
}
