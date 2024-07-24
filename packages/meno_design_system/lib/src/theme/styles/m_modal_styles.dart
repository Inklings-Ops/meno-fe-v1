// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MModalStyles extends ThemeExtension<MModalStyles> {
  final MColor? dragHandleColor;
  final MColor? backgroundColor;
  final MColor? modalBackgroundColor;

  MModalStyles({
    this.dragHandleColor,
    this.backgroundColor,
    this.modalBackgroundColor,
  });

  factory MModalStyles.$default(MColorScheme colors) {
    return MModalStyles(
      dragHandleColor: colors.outlineVariant1,
      backgroundColor: colors.background,
      modalBackgroundColor: colors.background,
    );
  }

  @override
  ThemeExtension<MModalStyles> copyWith({
    MColor? dragHandleColor,
    MColor? backgroundColor,
    MColor? modalBackgroundColor,
  }) {
    return MModalStyles(
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      modalBackgroundColor: modalBackgroundColor ?? this.modalBackgroundColor,
    );
  }

  @override
  ThemeExtension<MModalStyles> lerp(
    ThemeExtension<MModalStyles>? other,
    double t,
  ) {
    if (other is! MModalStyles) return this;
    return MModalStyles(
      dragHandleColor: MColor.lerp(dragHandleColor, other.dragHandleColor, t),
      backgroundColor: MColor.lerp(backgroundColor, other.backgroundColor, t),
      modalBackgroundColor:
          MColor.lerp(modalBackgroundColor, other.modalBackgroundColor, t),
    );
  }

  BottomSheetThemeData get bottomSheetTheme {
    final size =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    return BottomSheetThemeData(
      dragHandleSize: Size($styles.insets.xxLarge, $styles.insets.micro),
      showDragHandle: true,
      dragHandleColor: dragHandleColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.toScale)),
      ),
      backgroundColor: backgroundColor,
      modalBackgroundColor: modalBackgroundColor,
      constraints: BoxConstraints(maxHeight: size.height * 0.9).radius,
    );
  }

  static MModalStyles? of(BuildContext context) {
    return Theme.of(context).extension<MModalStyles>();
  }
}
