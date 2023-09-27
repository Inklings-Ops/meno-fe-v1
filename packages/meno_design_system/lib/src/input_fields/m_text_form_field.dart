import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_dimensions.dart';

class MTextFormField extends StatefulWidget {
  final String label;
  final IconData? labelIcon;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool enabled;
  final int maxLines;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool isPassword;
  final FormFieldValidator<String>? validator;

  const MTextFormField({
    super.key,
    required this.label,
    this.labelIcon,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<MTextFormField> createState() => _MTextFormFieldState();
}

class _MTextFormFieldState extends State<MTextFormField> {
  final _controllerNotifier = ValueNotifier<TextEditingController?>(null);
  final _focusNodeNotifier = ValueNotifier<FocusNode?>(null);

  int? currentLength;

  bool obscureText = false;
  bool hasError = false;

  String? errorText;

  Widget? suffixIcon, prefixIcon;

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    if (widget.prefixIcon != null && widget.maxLines == 1) {
      prefixIcon = _PrefixIcon(icon: widget.prefixIcon!);
    }

    if (widget.suffixIcon != null && widget.maxLines == 1) {
      suffixIcon = Icon(widget.suffixIcon, size: 16);
    }

    if (widget.isPassword) {
      suffixIcon = InkWell(
        onTap: () => setState(() => obscureText = !obscureText),
        child: _EyeIcon(obscureText),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Label(widget.label, icon: widget.labelIcon, hasError: hasError),
            if (widget.maxLines > 1)
              _Counter(
                maxLength: 244,
                currentLength: widget.controller?.text.length ?? 0,
                enabled: widget.enabled,
                hasError: hasError,
              ),
          ],
        ),
        MDimensions.verticalSpace8,
        TextFormField(
          style: styles.textStyle,
          initialValue: widget.initialValue,
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          obscureText: obscureText,
          maxLength: 244,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onChanged: widget.onChanged,
          obscuringCharacter: "*",
          maxLines: widget.maxLines,
          validator: onValidate,
          cursorWidth: 1,
          cursorHeight: 18,
          decoration: InputDecoration(
            enabled: widget.enabled,
            hintText: widget.hint,
            hintStyle: styles.hintTextStyle,
            contentPadding: const EdgeInsets.all(12),
            counter: const SizedBox(),
            fillColor:
                widget.enabled ? styles.fillColor : styles.fillColorDisabled,
            filled: true,
            iconColor: styles.iconColor,
            prefixIconColor: styles.iconColor,
            suffixIconColor: styles.iconColor,
            border: const OutlineInputBorder(
              borderRadius: MDimensions.mediumBorderRadius,
              borderSide: BorderSide(color: MColor.grey50, width: 1.0),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: MDimensions.mediumBorderRadius,
            ),
            prefixIconConstraints: BoxConstraints.tight(const Size(36, 34)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controllerNotifier.value = widget.controller;
    _focusNodeNotifier.value = widget.focusNode;
  }

  @override
  void didUpdateWidget(covariant MTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controllerNotifier.value = widget.controller;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNodeNotifier.value = widget.focusNode;
    }
  }

  String? onValidate(String? value) {
    setState(() {
      errorText = widget.validator?.call(value);
      hasError = errorText != null;
    });
    return errorText;
  }

  T resolveBorder<T>(bool isBoxed, T boxedValue, T underlinedValue) {
    return isBoxed ? boxedValue : underlinedValue;
  }
}

class _Counter extends StatelessWidget {
  final int maxLength;
  final int currentLength;
  final bool enabled;
  final bool hasError;

  const _Counter({
    required this.maxLength,
    required this.currentLength,
    this.enabled = true,
    this.hasError = true,
  });

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    final backgroundColor = (enabled && !hasError)
        ? styles.counterBgColor
        : styles.counterBgColorDisabled;

    final textColor = (enabled && !hasError)
        ? styles.counterTextColor
        : styles.counterTextColorDisabled;

    return Container(
      constraints: const BoxConstraints(minWidth: 49, maxHeight: 24),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: MDimensions.smallBorderRadius,
      ),
      child: MText(
        '$currentLength/$maxLength',
        textAlign: TextAlign.right,
        color: textColor,
        style: styles.counterTextStyle,
      ),
    );
  }
}

class _EyeIcon extends StatelessWidget {
  final bool obscureText;
  const _EyeIcon(this.obscureText);

  @override
  Widget build(BuildContext context) => obscureText
      ? const Icon(MIcons.eye, size: 16)
      : const Icon(MIcons.eye_off, size: 16);
}

class _Label extends StatelessWidget {
  final String label;
  final bool hasError;
  final IconData? icon;

  const _Label(this.label, {required this.hasError, this.icon});

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: hasError ? styles.errorColor : styles.iconColor,
          ),
          const SizedBox(width: 6),
        ],
        MText(
          label,
          color: hasError ? styles.errorColor : styles.textColor,
          style: hasError ? styles.labelTextStyleError : styles.labelTextStyle,
        ),
      ],
    );
  }
}

class _PrefixIcon extends StatelessWidget {
  final IconData icon;

  const _PrefixIcon({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 6.0, left: 2.0),
        child: Icon(icon, size: 16),
      );
}
