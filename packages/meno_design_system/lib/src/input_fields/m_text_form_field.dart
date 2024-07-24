import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'm_input_label.dart';

class MTextFormField extends StatefulWidget {
  const MTextFormField({
    super.key,
    required this.label,
    this.showLabel = true,
    this.autoFocus = false,
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

  final String label;
  final bool showLabel;
  final bool autoFocus;
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

  @override
  State<MTextFormField> createState() => _MTextFormFieldState();
}

class _MTextFormFieldState extends State<MTextFormField> {
  final _controllerNotifier = ValueNotifier<TextEditingController?>(null);

  late FocusNode _focus;
  bool _hasFocus = false;

  int? currentLength;

  late bool obscureText;

  Widget? suffixWidget, prefixWidget;

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    final iconColor = _hasFocus ? styles.iconColor! : MColor.grey80;

    if (widget.prefixIcon != null && widget.maxLines == 1) {
      prefixWidget = _PrefixIcon(icon: widget.prefixIcon!, color: iconColor);
    }

    if (widget.suffixIcon != null && widget.maxLines == 1) {
      suffixWidget = Icon(
        widget.suffixIcon,
        size: $styles.insets.xLarge,
        color: iconColor,
      );
    }

    if (widget.isPassword) {
      suffixWidget = InkWell(
        onTap: () => setState(() => obscureText = !obscureText),
        child: _EyeIcon(obscureText),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100.toScale),
      child: LayoutBuilder(
        builder: (context, constraints) => FormField<String?>(
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          builder: (field) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showLabel) ...[
                MInputLabel(
                  widget.label,
                  icon: widget.labelIcon,
                  required: widget.required,
                ),
                $styles.spaces.verticalSmall,
              ],
              SizedBox(
                height: (constraints.maxHeight * 0.48).toScale,
                child: _buildTextFormField(styles, iconColor, field),
              ),
              if (field.errorText != null) ...[
                $styles.spaces.verticalSmall,
                Container(
                  alignment: Alignment.centerLeft,
                  height: (constraints.maxHeight * 0.18).toScale,
                  child: _buildErrorText(field, styles),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controllerNotifier.value = widget.controller;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focus.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
    _controllerNotifier.value = widget.controller;
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focus.hasFocus);
  }

  T resolveBorder<T>(bool isBoxed, T boxedValue, T underlinedValue) {
    return isBoxed ? boxedValue : underlinedValue;
  }

  MText _buildErrorText(FormFieldState<String?> field, MTextFieldStyle styles) {
    return MText(
      field.errorText!,
      style: styles.errorTextStyle,
      color: styles.errorColor,
    );
  }

  TextFormField _buildTextFormField(
    MTextFieldStyle styles,
    MColor iconColor,
    FormFieldState<String?> field,
  ) {
    return TextFormField(
      autofocus: widget.autoFocus,
      autovalidateMode: widget.autovalidateMode,
      style: styles.textStyle,
      onFieldSubmitted: widget.onFieldSubmitted,
      initialValue: widget.initialValue,
      controller: widget.controller,
      focusNode: _focus,
      keyboardType: widget.keyboardType,
      obscureText: obscureText && widget.isPassword,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onChanged: widget.onChanged,
      obscuringCharacter: "*",
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      decoration: InputDecoration(
        enabled: widget.enabled,
        hintText: widget.hint,
        hintStyle: styles.hintTextStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: $styles.insets.medium),
        counter: null,
        fillColor: widget.enabled ? styles.fillColor : styles.fillColorDisabled,
        filled: true,
        iconColor: iconColor,
        prefixIconColor: iconColor,
        suffixIconColor: iconColor,
        border: field.hasError ? styles.borderError : styles.border,
        enabledBorder: field.hasError ? styles.borderError : styles.border,
        focusedBorder:
            field.hasError ? styles.borderError : styles.borderFocused,
        disabledBorder: styles.borderDisabled,
        error: const SizedBox(),
        prefixIconConstraints: BoxConstraints.tight(const Size(36, 48)).radius,
        prefixIcon: prefixWidget,
        suffixIconConstraints: BoxConstraints.tight(const Size(36, 48)).radius,
        suffixIcon: suffixWidget,
      ),
    );
  }
}

class _EyeIcon extends StatelessWidget {
  const _EyeIcon(this.obscureText);
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final iconSize = $styles.insets.xLarge;
    return Container(
      height: iconSize,
      width: iconSize,
      margin: EdgeInsets.only(right: $styles.insets.medium),
      child: obscureText
          ? Icon(MIcons.eye, size: iconSize)
          : Icon(MIcons.eye_off, size: iconSize),
    );
  }
}

class _PrefixIcon extends StatelessWidget {
  const _PrefixIcon({required this.icon, this.color});
  final IconData icon;
  final MColor? color;

  @override
  Widget build(BuildContext context) {
    final iconSize = $styles.insets.xLarge;
    return Container(
      width: iconSize,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(right: 6).radius,
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
