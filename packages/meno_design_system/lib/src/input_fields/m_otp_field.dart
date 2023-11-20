import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../m_dimensions.dart';
import '../theme/styles/m_otp_field_style.dart';
import '../theme/styles/m_text_style.dart';

class MOtpField extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final FocusNode? focusNode;
  final int length;
  final bool obscureText;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  const MOtpField({
    super.key,
    this.controller,
    this.enabled = true,
    this.focusNode,
    this.length = 4,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final MOtpFieldStyles? styles = MOtpFieldStyles.of(context);

    final defaultPinTheme = PinTheme(
      constraints: const BoxConstraints(maxHeight: 88, maxWidth: 88),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: styles?.fillColor,
        border: styles?.border,
        borderRadius: MDimensions.mediumBorderRadius,
      ),
      textStyle: MTextStyle.heading1Medium.toTextStyle.copyWith(
        color: styles?.textStyle?.color,
      ),
    );

    return Pinput(
      autofocus: true,
      controller: controller,
      enabled: enabled,
      focusNode: focusNode,
      length: length,
      obscureText: obscureText,
      obscuringCharacter: "*",
      onChanged: onChanged,
      validator: validator,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        color: styles?.fillColor,
        border: styles?.borderFocused,
        borderRadius: MDimensions.mediumBorderRadius,
      ),
      errorPinTheme: defaultPinTheme.copyDecorationWith(
        color: styles?.fillColor,
        border: styles?.borderError,
        borderRadius: MDimensions.mediumBorderRadius,
      ),
    );
  }
}
