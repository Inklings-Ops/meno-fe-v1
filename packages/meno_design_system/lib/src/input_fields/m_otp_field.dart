import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:pinput/pinput.dart';

class MOtpField extends StatelessWidget {
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

  final TextEditingController? controller;
  final bool enabled;
  final FocusNode? focusNode;
  final int length;
  final bool obscureText;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final styles = MOtpFieldStyles.of(context);
    final defaultPinTheme = PinTheme(
      constraints: const BoxConstraints(maxHeight: 88, maxWidth: 88).radius,
      padding: const EdgeInsets.all(24.0).radius,
      decoration: BoxDecoration(
        color: styles?.fillColor,
        border: styles?.border,
        borderRadius: $styles.radius.medium,
      ),
      textStyle: $styles.text.heading1Medium.copyWith(
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
        borderRadius: $styles.radius.medium,
      ),
      errorPinTheme: defaultPinTheme.copyDecorationWith(
        color: styles?.fillColor,
        border: styles?.borderError,
        borderRadius: $styles.radius.medium,
      ),
    );
  }
}
