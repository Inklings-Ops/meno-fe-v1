import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTextFormField extends StatefulWidget {
  final String label;
  final bool showLabel;
  final IconData? labelIcon;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool required;
  final TextInputAction? textInputAction;

  const MTextFormField({
    super.key,
    required this.label,
    this.showLabel = true,
    this.labelIcon,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.autovalidateMode,
    this.required = false,
    this.textInputAction,
  });

  @override
  State<MTextFormField> createState() => _MTextFormFieldState();
}

class _MTextFormFieldState extends State<MTextFormField> {
  final _controllerNotifier = ValueNotifier<TextEditingController?>(null);
  final _focusNodeNotifier = ValueNotifier<FocusNode?>(null);

  int? currentLength;

  late bool obscureText;

  Widget? suffixIcon, prefixIcon;

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    final bool hasFocus = widget.focusNode?.hasFocus == true;

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

    final MColor? effectiveIconColor =
        hasFocus ? styles.iconColor : MColor.grey80;

    final MColor? effectiveFillColor =
        widget.enabled ? styles.fillColor : styles.fillColorDisabled;

    return FormField<String?>(
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (field) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showLabel) ...[
            LimitedBox(
              maxHeight: 18.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Label(
                    widget.label,
                    icon: widget.labelIcon,
                    hasError: field.hasError,
                    required: widget.required,
                  ),
                  if (widget.maxLines > 1)
                    _Counter(
                      maxLength: widget.maxLength ?? 244,
                      currentLength:
                          _controllerNotifier.value?.text.length ?? 0,
                      enabled: widget.enabled,
                      hasError: field.hasError,
                    ),
                ],
              ),
            ),
            MSize.verticalSpaceSmall,
          ],
          TextFormField(
            autovalidateMode: widget.autovalidateMode,
            style: styles.textStyle?.copyWith(
              color: widget.focusNode?.hasFocus == true
                  ? styles.textColor
                  : MColor.grey80,
            ),
            onFieldSubmitted: widget.onFieldSubmitted,
            initialValue: widget.initialValue,
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            obscureText: obscureText && widget.isPassword,
            textInputAction: widget.textInputAction,
            maxLength: 244,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: widget.onChanged,
            obscuringCharacter: "*",
            maxLines: widget.maxLines,
            cursorWidth: 1,
            cursorHeight: 18,
            enabled: widget.enabled,
            decoration: InputDecoration(
              enabled: widget.enabled,
              hintText: widget.hint,
              hintStyle: styles.hintTextStyle,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              counter: const SizedBox(),
              fillColor: effectiveFillColor,
              filled: true,
              iconColor: effectiveIconColor,
              prefixIconColor: effectiveIconColor,
              suffixIconColor: effectiveIconColor,
              enabledBorder:
                  field.hasError ? styles.borderError : styles.border,
              focusedBorder:
                  field.hasError ? styles.borderError : styles.border,
              disabledBorder: styles.borderDisabled,
              prefixIconConstraints: BoxConstraints.tight(const Size(36, 34)),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
          if (field.errorText != null)
            Container(
              alignment: Alignment.centerLeft,
              height: 18,
              child: MText(
                field.errorText!,
                style: styles.errorTextStyle,
                color: styles.errorColor,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
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
  final bool required;

  const _Label(
    this.label, {
    required this.hasError,
    this.icon,
    this.required = false,
  });

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
          style: styles.labelTextStyle,
        ),
        if (required) ...[
          6.horizontalSpace,
          MText(
            "*",
            color: styles.errorColor,
            style: styles.labelTextStyle,
          ),
        ],
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
