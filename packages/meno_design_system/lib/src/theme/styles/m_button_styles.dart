import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

ButtonStyle get _baseButtonStyle => ButtonStyle(
      iconSize: MInternal.resolveWith(defaultValue: 14.0.toScale),
      elevation: MInternal.resolveWith(defaultValue: 0.0),
      fixedSize: MInternal.all(Size.fromHeight($styles.insets.xxxLarge)),
      padding: MInternal.all(const EdgeInsets.fromLTRB(16, 8, 16, 8).radius),
      shadowColor: MInternal.all(MColor.shadow),
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: MInternal.all($styles.text.captionMedium),
      shape: MInternal.all(
        RoundedRectangleBorder(borderRadius: $styles.radius.medium),
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

  factory MButtonStyles.$default(MColorScheme colors) {
    return MButtonStyles(
      primary: _baseButtonStyle.copyWith(
        backgroundColor: MInternal.resolveWith(
          defaultValue: colors.primary!,
          pressedValue: colors.inversePrimary,
          disabledValue: colors.disabled,
        ),
        foregroundColor: MInternal.resolveWith(
          defaultValue: colors.onPrimary!,
          pressedValue: colors.onInversePrimary,
          disabledValue: colors.onDisabled,
        ),
        iconColor: MInternal.resolveWith(
          defaultValue: colors.onPrimary!,
          pressedValue: colors.onInversePrimary,
          disabledValue: colors.onDisabled,
        ),
        textStyle: MInternal.all($styles.text.bodyMedium),
      ),
      secondary: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: MColor.transparent,
            pressedValue: colors.inversePrimary,
            disabledValue: colors.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colors.primary!,
            pressedValue: colors.onInversePrimary,
            disabledValue: colors.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colors.primary!,
            pressedValue: colors.onInversePrimary,
            disabledValue: colors.onDisabled,
          ),
          side: MInternal.resolveWith(
            defaultValue: BorderSide(
              color: colors.primary!,
              width: 1.50.toScale,
            ),
            pressedValue: BorderSide(
              color: colors.primary!,
              width: 1.50.toScale,
            ),
            disabledValue: const BorderSide(width: 0),
          ),
        ),
      ),
      text: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: MColor.transparent,
            pressedValue: MColor.transparent,
            disabledValue: colors.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colors.primary!,
            pressedValue: colors.onInversePrimary,
            disabledValue: colors.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colors.primary!,
            pressedValue: colors.onInversePrimary,
            disabledValue: colors.onDisabled,
          ),
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      success: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: colors.success!,
            pressedValue: colors.successContainer,
            disabledValue: colors.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colors.onSuccess!,
            pressedValue: colors.onSuccessContainer!,
            disabledValue: colors.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colors.onSuccess!,
            pressedValue: colors.onSuccessContainer!,
            disabledValue: colors.onDisabled,
          ),
        ),
      ),
      danger: _baseButtonStyle.merge(
        ButtonStyle(
          backgroundColor: MInternal.resolveWith(
            defaultValue: colors.error!,
            pressedValue: colors.errorContainer,
            disabledValue: colors.disabled,
          ),
          foregroundColor: MInternal.resolveWith(
            defaultValue: colors.onError!,
            pressedValue: colors.onErrorContainer!,
            disabledValue: colors.onDisabled,
          ),
          iconColor: MInternal.resolveWith(
            defaultValue: colors.onError!,
            pressedValue: colors.onErrorContainer!,
            disabledValue: colors.onDisabled,
          ),
          shape: MInternal.all(
            RoundedRectangleBorder(borderRadius: $styles.radius.small),
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
