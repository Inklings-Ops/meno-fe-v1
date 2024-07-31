import 'package:flutter/material.dart';
import 'package:meno_design_system/src/m_internal.dart';
import 'package:meno_design_system/src/theme/m_color.dart';

/// A custom theme extension for managing colors within the app.
///
/// The [MColorScheme] class extends [ThemeExtension] to define a collection of
/// colors used throughout the application. This helps in maintaining a
/// consistent color scheme and allows for easy customization of colors
/// based on the application's color scheme.
class MColorScheme extends ThemeExtension<MColorScheme> {
  /// Creates an [MColorScheme] instance with the provided color scheme.
  ///
  /// All colors in the scheme are optional and can be customized individually.
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
    this.informational,
    this.onInformational,
    this.informationalContainer,
    this.onInformationalContainer,
    this.warning,
    this.onWarning,
    this.warningContainer,
    this.onWarningContainer,
    this.success,
    this.onSuccess,
    this.successContainer,
    this.onSuccessContainer,
    this.notification,
    this.onNotification,
    this.inActive,
    this.onInActive,
    this.inActiveContainer,
    this.onInActiveContainer,
    this.disabled,
    this.onDisabled,
    this.disabledContainer,
    this.onDisabledContainer,
    this.background,
    this.onBackground,
    this.onBackgroundProminent,
    this.onBackgroundVariant,
    this.surface,
    this.onSurface,
    this.surfaceTint,
    this.surfaceShade,
    this.onSurfaceShade,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.onInversePrimary,
    this.scrim,
    this.shadow,
    this.outline,
    this.outlineVariant1,
    this.outlineVariant2,
    this.outlineVariant3,
  });

  /// Provides the default [MColorScheme] for the app based on the given
  /// [brightness].
  ///
  /// This factory method initializes an [MColorScheme] instance using
  /// a predefined set of colors.
  factory MColorScheme.$default(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return MColorScheme(
      brightness: brightness,
      primary: MInternal.resolve(isLight, MColor.primary300, MColor.primary75),
      onPrimary: MInternal.resolve(isLight, MColor.white, MColor.primary700),
      primaryContainer:
          MInternal.resolve(isLight, MColor.primary50, MColor.primary600),
      onPrimaryContainer:
          MInternal.resolve(isLight, MColor.primary700, MColor.primary50),
      secondary:
          MInternal.resolve(isLight, MColor.secondary300, MColor.secondary75),
      onSecondary:
          MInternal.resolve(isLight, MColor.white, MColor.secondary600),
      secondaryContainer:
          MInternal.resolve(isLight, MColor.secondary50, MColor.secondary75),
      onSecondaryContainer: MColor.secondary600,
      tertiary: MInternal.resolve(
        isLight,
        MColor.decorativeYellow75,
        MColor.decorativeYellow200,
      ),
      onTertiary: MColor.black,
      tertiaryContainer: MColor.decorativeYellow50,
      onTertiaryContainer: MColor.black,
      error: MInternal.resolve(isLight, MColor.error300, MColor.error75),
      onError: MInternal.resolve(isLight, MColor.white, MColor.error600),
      errorContainer:
          MInternal.resolve(isLight, MColor.error75, MColor.error500),
      onErrorContainer:
          MInternal.resolve(isLight, MColor.error600, MColor.error75),
      informational: MInternal.resolve(isLight, MColor.blue300, MColor.blue75),
      onInformational: MInternal.resolve(isLight, MColor.white, MColor.blue600),
      informationalContainer:
          MInternal.resolve(isLight, MColor.blue50, MColor.secondary500),
      onInformationalContainer:
          MInternal.resolve(isLight, MColor.blue300, MColor.secondary50),
      warning: MInternal.resolve(isLight, MColor.yellow300, MColor.yellow75),
      onWarning: MInternal.resolve(isLight, MColor.white, MColor.yellow600),
      warningContainer:
          MInternal.resolve(isLight, MColor.yellow75, MColor.yellow500),
      onWarningContainer:
          MInternal.resolve(isLight, MColor.yellow600, MColor.yellow50),
      success: MInternal.resolve(isLight, MColor.success300, MColor.success75),
      onSuccess: MInternal.resolve(isLight, MColor.white, MColor.success600),
      successContainer:
          MInternal.resolve(isLight, MColor.success75, MColor.success500),
      onSuccessContainer:
          MInternal.resolve(isLight, MColor.success600, MColor.success50),
      notification: MInternal.resolve(isLight, MColor.error300, MColor.error75),
      onNotification:
          MInternal.resolve(isLight, MColor.white, MColor.success600),
      inActive: MInternal.resolve(isLight, MColor.grey70, MColor.grey50),
      onInActive: MInternal.resolve(isLight, MColor.grey900, MColor.grey200),
      inActiveContainer:
          MInternal.resolve(isLight, MColor.grey30, MColor.grey300),
      onInActiveContainer:
          MInternal.resolve(isLight, MColor.grey500, MColor.grey10),
      disabled: MInternal.resolve(isLight, MColor.grey50, MColor.primary600),
      onDisabled: MInternal.resolve(isLight, MColor.grey900, MColor.grey10),
      disabledContainer:
          MInternal.resolve(isLight, MColor.grey30, MColor.primary600),
      onDisabledContainer:
          MInternal.resolve(isLight, MColor.grey500, MColor.grey200),
      background: MInternal.resolve(isLight, MColor.white, MColor.primary700),
      onBackground: MInternal.resolve(isLight, MColor.black, MColor.white),
      surface: MInternal.resolve(isLight, MColor.white, MColor.primary700),
      onSurface: MInternal.resolve(isLight, MColor.black, MColor.white),
      onBackgroundProminent:
          MInternal.resolve(isLight, MColor.primary600, MColor.primary50),
      onBackgroundVariant: MColor.grey80,
      surfaceTint: MInternal.resolve(isLight, MColor.tint, MColor.primaryAlt),
      surfaceShade: MInternal.resolve(isLight, MColor.tint, MColor.primaryAlt),
      onSurfaceShade: MInternal.resolve(isLight, MColor.grey200, MColor.grey30),
      inverseSurface:
          MInternal.resolve(isLight, MColor.primary600, MColor.primary75),
      onInverseSurface:
          MInternal.resolve(isLight, MColor.white, MColor.primary600),
      inversePrimary:
          MInternal.resolve(isLight, MColor.primary75, MColor.primary200),
      onInversePrimary:
          MInternal.resolve(isLight, MColor.primary600, MColor.white),
      scrim: MColor.n0,
      shadow: MColor.shadow,
      outline: MInternal.resolve(isLight, MColor.primary300, MColor.primary75),
      outlineVariant1:
          MInternal.resolve(isLight, MColor.grey30, MColor.grey400),
      outlineVariant2:
          MInternal.resolve(isLight, MColor.grey30, MColor.grey400),
      outlineVariant3:
          MInternal.resolve(isLight, MColor.grey50, MColor.grey200),
    );
  }

  /// The [brightness] color
  final Brightness? brightness;

  /// The [primary] color
  final MColor? primary;

  /// The [onPrimary] color
  final MColor? onPrimary;

  /// The [primaryContainer] color
  final MColor? primaryContainer;

  /// The [onPrimaryContainer] color
  final MColor? onPrimaryContainer;

  /// The [secondary] color
  final MColor? secondary;

  /// The [onSecondary] color
  final MColor? onSecondary;

  /// The [secondaryContainer] color
  final MColor? secondaryContainer;

  /// The [onSecondaryContainer] color
  final MColor? onSecondaryContainer;

  /// The [tertiary] color
  final MColor? tertiary;

  /// The [onTertiary] color
  final MColor? onTertiary;

  /// The [tertiaryContainer] color
  final MColor? tertiaryContainer;

  /// The [onTertiaryContainer] color
  final MColor? onTertiaryContainer;

  /// The [error] color
  final MColor? error;

  /// The [onError] color
  final MColor? onError;

  /// The [errorContainer] color
  final MColor? errorContainer;

  /// The [onErrorContainer] color
  final MColor? onErrorContainer;

  /// The [informational] color
  final MColor? informational;

  /// The [onInformational] color
  final MColor? onInformational;

  /// The [informationalContainer] color
  final MColor? informationalContainer;

  /// The [onInformationalContainer] color
  final MColor? onInformationalContainer;

  /// The [warning] color
  final MColor? warning;

  /// The [onWarning] color
  final MColor? onWarning;

  /// The [warningContainer] color
  final MColor? warningContainer;

  /// The [onWarningContainer] color
  final MColor? onWarningContainer;

  /// The [success] color
  final MColor? success;

  /// The [onSuccess] color
  final MColor? onSuccess;

  /// The [successContainer] color
  final MColor? successContainer;

  /// The [onSuccessContainer] color
  final MColor? onSuccessContainer;

  /// The [notification] color
  final MColor? notification;

  /// The [onNotification] color
  final MColor? onNotification;

  /// The [inActive] color
  final MColor? inActive;

  /// The [onInActive] color
  final MColor? onInActive;

  /// The [inActiveContainer] color
  final MColor? inActiveContainer;

  /// The [onInActiveContainer] color
  final MColor? onInActiveContainer;

  /// The [disabled] color
  final MColor? disabled;

  /// The [onDisabled] color
  final MColor? onDisabled;

  /// The [disabledContainer] color
  final MColor? disabledContainer;

  /// The [onDisabledContainer] color
  final MColor? onDisabledContainer;

  /// The [background] color
  final MColor? background;

  /// The [onBackground] color
  final MColor? onBackground;

  /// The [onBackgroundProminent] color
  final MColor? onBackgroundProminent;

  /// The [onBackgroundVariant] color
  final MColor? onBackgroundVariant;

  /// The [surface] color
  final MColor? surface;

  /// The [onSurface] color
  final MColor? onSurface;

  /// The [surfaceTint] color
  final MColor? surfaceTint;

  /// The [surfaceShade] color
  final MColor? surfaceShade;

  /// The [onSurfaceShade] color
  final MColor? onSurfaceShade;

  /// The [inverseSurface] color
  final MColor? inverseSurface;

  /// The [onInverseSurface] color
  final MColor? onInverseSurface;

  /// The [inversePrimary] color
  final MColor? inversePrimary;

  /// The [onInversePrimary] color
  final MColor? onInversePrimary;

  /// The [scrim] color
  final MColor? scrim;

  /// The [shadow] color
  final MColor? shadow;

  /// The [outline] color
  final MColor? outline;

  /// The [outlineVariant1] color
  final MColor? outlineVariant1;

  /// The [outlineVariant2] color
  final MColor? outlineVariant2;

  /// The [outlineVariant3] color
  final MColor? outlineVariant3;

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
    MColor? informational,
    MColor? onInformational,
    MColor? informationalContainer,
    MColor? onInformationalContainer,
    MColor? warning,
    MColor? onWarning,
    MColor? warningContainer,
    MColor? onWarningContainer,
    MColor? success,
    MColor? onSuccess,
    MColor? successContainer,
    MColor? onSuccessContainer,
    MColor? notification,
    MColor? onNotification,
    MColor? inActive,
    MColor? onInActive,
    MColor? inActiveContainer,
    MColor? onInActiveContainer,
    MColor? disabled,
    MColor? onDisabled,
    MColor? disabledContainer,
    MColor? onDisabledContainer,
    MColor? background,
    MColor? onBackground,
    MColor? onBackgroundProminent,
    MColor? onBackgroundVariant,
    MColor? surface,
    MColor? onSurface,
    MColor? surfaceTint,
    MColor? surfaceShade,
    MColor? onSurfaceShade,
    MColor? inverseSurface,
    MColor? onInverseSurface,
    MColor? inversePrimary,
    MColor? onInversePrimary,
    MColor? scrim,
    MColor? shadow,
    MColor? outline,
    MColor? outlineVariant1,
    MColor? outlineVariant2,
    MColor? outlineVariant3,
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
      informational: informational ?? this.informational,
      onInformational: onInformational ?? this.onInformational,
      informationalContainer:
          informationalContainer ?? this.informationalContainer,
      onInformationalContainer:
          onInformationalContainer ?? this.onInformationalContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      notification: notification ?? this.notification,
      onNotification: onNotification ?? this.onNotification,
      inActive: inActive ?? this.inActive,
      onInActive: onInActive ?? this.onInActive,
      inActiveContainer: inActiveContainer ?? this.inActiveContainer,
      onInActiveContainer: onInActiveContainer ?? this.onInActiveContainer,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      disabledContainer: disabledContainer ?? this.disabledContainer,
      onDisabledContainer: onDisabledContainer ?? this.onDisabledContainer,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      onBackgroundProminent:
          onBackgroundProminent ?? this.onBackgroundProminent,
      onBackgroundVariant: onBackgroundVariant ?? this.onBackgroundVariant,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      surfaceShade: surfaceShade ?? this.surfaceShade,
      onSurfaceShade: onSurfaceShade ?? this.onSurfaceShade,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      onInversePrimary: onInversePrimary ?? this.onInversePrimary,
      scrim: scrim ?? this.scrim,
      shadow: shadow ?? this.shadow,
      outline: outline ?? this.outline,
      outlineVariant1: outlineVariant1 ?? this.outlineVariant1,
      outlineVariant2: outlineVariant2 ?? this.outlineVariant2,
      outlineVariant3: outlineVariant3 ?? this.outlineVariant3,
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
      informational: MColor.lerp(informational, other.informational, t),
      onInformational: MColor.lerp(onInformational, other.onInformational, t),
      informationalContainer:
          MColor.lerp(informationalContainer, other.informationalContainer, t),
      onInformationalContainer: MColor.lerp(
        onInformationalContainer,
        other.onInformationalContainer,
        t,
      ),
      warning: MColor.lerp(warning, other.warning, t),
      onWarning: MColor.lerp(onWarning, other.onWarning, t),
      warningContainer:
          MColor.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer:
          MColor.lerp(onWarningContainer, other.onWarningContainer, t),
      success: MColor.lerp(success, other.success, t),
      onSuccess: MColor.lerp(onSuccess, other.onSuccess, t),
      successContainer:
          MColor.lerp(successContainer, other.successContainer, t),
      onSuccessContainer:
          MColor.lerp(onSuccessContainer, other.onSuccessContainer, t),
      notification: MColor.lerp(notification, other.notification, t),
      onNotification: MColor.lerp(onNotification, other.onNotification, t),
      inActive: MColor.lerp(inActive, other.inActive, t),
      onInActive: MColor.lerp(onInActive, other.onInActive, t),
      inActiveContainer:
          MColor.lerp(inActiveContainer, other.inActiveContainer, t),
      onInActiveContainer:
          MColor.lerp(onInActiveContainer, other.onInActiveContainer, t),
      disabled: MColor.lerp(disabled, other.disabled, t),
      onDisabled: MColor.lerp(onDisabled, other.onDisabled, t),
      disabledContainer:
          MColor.lerp(disabledContainer, other.disabledContainer, t),
      onDisabledContainer:
          MColor.lerp(onDisabledContainer, other.onDisabledContainer, t),
      background: MColor.lerp(background, other.background, t),
      onBackground: MColor.lerp(onBackground, other.onBackground, t),
      onBackgroundProminent:
          MColor.lerp(onBackgroundProminent, other.onBackgroundProminent, t),
      onBackgroundVariant:
          MColor.lerp(onBackgroundVariant, other.onBackgroundVariant, t),
      surface: MColor.lerp(surface, other.surface, t),
      onSurface: MColor.lerp(onSurface, other.onSurface, t),
      surfaceTint: MColor.lerp(surfaceTint, other.surfaceTint, t),
      surfaceShade: MColor.lerp(surfaceShade, other.surfaceShade, t),
      onSurfaceShade: MColor.lerp(onSurfaceShade, other.onSurfaceShade, t),
      inverseSurface: MColor.lerp(inverseSurface, other.inverseSurface, t),
      onInverseSurface:
          MColor.lerp(onInverseSurface, other.onInverseSurface, t),
      inversePrimary: MColor.lerp(inversePrimary, other.inversePrimary, t),
      onInversePrimary:
          MColor.lerp(onInversePrimary, other.onInversePrimary, t),
      scrim: MColor.lerp(scrim, other.scrim, t),
      shadow: MColor.lerp(shadow, other.shadow, t),
      outline: MColor.lerp(outline, other.outline, t),
      outlineVariant1: MColor.lerp(outlineVariant1, other.outlineVariant1, t),
      outlineVariant2: MColor.lerp(outlineVariant2, other.outlineVariant2, t),
      outlineVariant3: MColor.lerp(outlineVariant3, other.outlineVariant3, t),
    );
  }

  /// Retrieves the [MColorScheme] extension from the closest [Theme] instance
  /// that encloses the given [context].
  ///
  /// This method searches for the nearest [Theme] widget in the widget tree
  /// and returns the [MColorScheme] extension if it exists. If no
  /// [MColorScheme] extension is found, this method returns null.
  ///
  /// The [MColorScheme] extension must be added to the [ThemeData.extensions]
  /// in your theme configuration to be accessible using this method.
  ///
  /// Example usage:
  /// ```dart
  /// final mColorScheme = MColorScheme.of(context);
  /// ```
  ///
  /// - [context]: The build context from which to retrieve the [MColorScheme]
  /// extension.
  ///
  /// Returns the [MColorScheme] extension if found, or null if no
  /// [MColorScheme] extension is available in the closest [Theme] instance.
  static MColorScheme? of(BuildContext context) {
    return Theme.of(context).extension<MColorScheme>();
  }

  /// Creates the [ColorScheme] based the [MColorScheme] extension
  ColorScheme get getColorScheme {
    return ColorScheme(
      brightness: brightness!,
      primary: primary!,
      onPrimary: onPrimary!,
      onPrimaryContainer: onPrimaryContainer,
      primaryContainer: primaryContainer,
      secondary: secondary!,
      onSecondary: onSecondary!,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error!,
      onError: onError!,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface!,
      onSurface: onSurface!,
      surfaceTint: surfaceTint,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      outline: outline,
      outlineVariant: outlineVariant1,
      scrim: scrim,
      shadow: shadow,
    );
  }
}
