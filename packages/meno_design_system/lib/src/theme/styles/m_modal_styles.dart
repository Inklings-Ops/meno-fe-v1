// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../m_core.dart';
import '../m_color.dart';
import '../m_color_scheme.dart';

class MModalStyles extends ThemeExtension<MModalStyles> {
  final MColor? dragHandleColor;
  final MColor? backgroundColor;
  final MColor? modalBackgroundColor;

  MModalStyles({
    this.dragHandleColor,
    this.backgroundColor,
    this.modalBackgroundColor,
  });

  factory MModalStyles.$default({required MColorScheme colorScheme}) {
    return MModalStyles(
      dragHandleColor: colorScheme.outlineVariant1,
      backgroundColor: colorScheme.background,
      modalBackgroundColor: colorScheme.background,
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
    final Size size =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    return BottomSheetThemeData(
      dragHandleSize: const Size(32, 4),
      showDragHandle: true,
      dragHandleColor: dragHandleColor,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(MCore.xxLarge)),
      ),
      backgroundColor: backgroundColor,
      modalBackgroundColor: modalBackgroundColor,
      constraints: BoxConstraints(maxHeight: size.height * 0.9),
    );
  }

  static MModalStyles? of(BuildContext context) {
    return Theme.of(context).extension<MModalStyles>();
  }
}
