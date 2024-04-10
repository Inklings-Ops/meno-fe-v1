import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../m_size.dart';
import 'm_input_label.dart';

class MTextFormField extends StatefulWidget {
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
      suffixWidget = Icon(widget.suffixIcon, size: 20, color: iconColor);
    }

    if (widget.isPassword) {
      suffixWidget = InkWell(
        onTap: () => setState(() => obscureText = !obscureText),
        child: _EyeIcon(obscureText),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 100),
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
                MSize.verticalSpaceSmall,
              ],
              SizedBox(
                height: constraints.maxHeight * 0.48,
                child: _buildTextFormField(styles, iconColor, field),
              ),
              if (field.errorText != null)
                Container(
                  alignment: Alignment.centerLeft,
                  height: constraints.maxHeight * 0.18,
                  child: _buildErrorText(field, styles),
                ),
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
      cursorWidth: 1,
      cursorHeight: 18,
      decoration: InputDecoration(
        enabled: widget.enabled,
        hintText: widget.hint,
        hintStyle: styles.hintTextStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: MCore.medium),
        counter: const SizedBox(),
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
        prefixIconConstraints: BoxConstraints.tight(const Size(36, 20)),
        prefixIcon: prefixWidget,
        suffixIconConstraints: BoxConstraints.tight(const Size(32, 20)),
        suffixIcon: suffixWidget,
      ),
    );
  }
}

class _EyeIcon extends StatelessWidget {
  final bool obscureText;
  const _EyeIcon(this.obscureText);

  @override
  Widget build(BuildContext context) => Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.only(right: MCore.medium),
        child: obscureText
            ? const Icon(MIcons.eye, size: 20)
            : const Icon(MIcons.eye_off, size: 20),
      );
}

class _PrefixIcon extends StatelessWidget {
  final IconData icon;
  final MColor? color;

  const _PrefixIcon({required this.icon, this.color});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 6.0, left: 2.0),
        child: Icon(icon, size: 20, color: color),
      );
}
