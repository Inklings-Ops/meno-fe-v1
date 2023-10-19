import 'package:flutter/material.dart';
import 'package:meno_design_system/src/m_size.dart';

import '../../m_internal.dart';
import '../m_color.dart';
import '../m_color_scheme.dart';

ButtonStyle get _baseButtonStyle => ButtonStyle(
      iconSize: MInternal.resolveWith(defaultValue: 14.0),
      elevation: MInternal.resolveWith(defaultValue: 0.0),
      fixedSize: MInternal.all(const Size.fromHeight(MCore.xxxLarge)),
      padding: MInternal.all(const EdgeInsets.fromLTRB(16, 8, 16, 8)),
      shadowColor: MInternal.all(MColor.shadow),
      shape: MInternal.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MCore.medium)),
        ),
      ),
    );

class MButtonStyles extends ThemeExtension<MButtonStyles> {
  final ButtonStyle? primary;
  final ButtonStyle? secondary;
  final ButtonStyle? text;
  final ButtonStyle? success;
  final ButtonStyle? danger;

  MButtonStyles({
    this.primary,
    this.secondary,
    this.text,
    this.success,
    this.danger,
  });

  factory MButtonStyles.$default({required MColorScheme colorScheme}) {
    return MButtonStyles(
      primary: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.primary!,
            pressedValue: colorScheme.inversePrimary,
            disabledValue: colorScheme.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.onPrimary!,
            pressedValue: colorScheme.onInversePrimary,
            disabledValue: colorScheme.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colorScheme.onPrimary!,
            pressedValue: colorScheme.onInversePrimary,
            disabledValue: colorScheme.onDisabled,
          ),
        ),
      ),
      secondary: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: MColor.transparent,
            pressedValue: colorScheme.inversePrimary,
            disabledValue: colorScheme.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.primary!,
            pressedValue: colorScheme.onInversePrimary,
            disabledValue: colorScheme.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colorScheme.primary!,
            pressedValue: colorScheme.onInversePrimary,
            disabledValue: colorScheme.onDisabled,
          ),
          side: MInternal.resolveWith(
            defaultValue: BorderSide(color: colorScheme.primary!, width: 1.50),
            pressedValue: BorderSide(color: colorScheme.primary!, width: 1.50),
            disabledValue: const BorderSide(width: 0),
          ),
        ),
      ),
      text: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: MColor.transparent,
            pressedValue: MColor.transparent,
            disabledValue: colorScheme.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.primary!,
            pressedValue: colorScheme.onInversePrimary,
            disabledValue: colorScheme.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colorScheme.primary!,
            pressedValue: colorScheme.onInversePrimary,
            disabledValue: colorScheme.onDisabled,
          ),
        ),
      ),
      success: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.success!,
            pressedValue: colorScheme.successContainer,
            disabledValue: colorScheme.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.onSuccess!,
            pressedValue: colorScheme.onSuccessContainer!,
            disabledValue: colorScheme.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colorScheme.onSuccess!,
            pressedValue: colorScheme.onSuccessContainer!,
            disabledValue: colorScheme.onDisabled,
          ),
        ),
      ),
      danger: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.error!,
            pressedValue: colorScheme.errorContainer,
            disabledValue: colorScheme.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colorScheme.onError!,
            pressedValue: colorScheme.onErrorContainer!,
            disabledValue: colorScheme.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colorScheme.onError!,
            pressedValue: colorScheme.onErrorContainer!,
            disabledValue: colorScheme.onDisabled,
          ),
        ),
      ),
    );
  }

  ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(style: primary);
  }

  OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(style: secondary);
  }

  TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(style: text);
  }

  @override
  ThemeExtension<MButtonStyles> copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? text,
    ButtonStyle? success,
    ButtonStyle? danger,
  }) {
    return MButtonStyles(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      text: text ?? this.text,
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<MButtonStyles> lerp(
    ThemeExtension<MButtonStyles>? other,
    double t,
  ) {
    if (other is! MButtonStyles) return this;
    return MButtonStyles(
      primary: ButtonStyle.lerp(primary, other.primary, t),
      secondary: ButtonStyle.lerp(secondary, other.secondary, t),
      text: ButtonStyle.lerp(text, other.text, t),
      success: ButtonStyle.lerp(success, other.success, t),
      danger: ButtonStyle.lerp(danger, other.danger, t),
    );
  }

  static MButtonStyles? of(BuildContext context) {
    return Theme.of(context).extension<MButtonStyles>();
  }
}
