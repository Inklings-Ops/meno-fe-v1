import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'm_input_counter.dart';
import 'm_input_label.dart';

class MTextArea extends StatefulWidget {
  const MTextArea({
    super.key,
    required this.label,
    this.labelIcon,
    this.hint,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.autovalidateMode,
    this.required = false,
    this.textInputAction,
  });

  final String label;
  final IconData? labelIcon;
  final String? hint;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool required;
  final TextInputAction? textInputAction;

  @override
  State<MTextArea> createState() => _MTextAreaState();
}

class _MTextAreaState extends State<MTextArea> {
  final _controllerNotifier = ValueNotifier<TextEditingController?>(null);

  late FocusNode _focus;
  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context)!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 168).radius,
      child: FormField<String?>(
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        builder: (field) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MInputLabel(
                  widget.label,
                  icon: widget.labelIcon,
                  required: widget.required,
                ),
                MInputCounter(
                  maxLength: widget.maxLength ?? 244,
                  currentLength: _controllerNotifier.value?.text.length ?? 0,
                  enabled: widget.enabled || field.hasError,
                ),
              ],
            ),
            $styles.spaces.verticalSmall,
            LimitedBox(
              maxHeight: 136.toScale,
              child: _buildTextFormField(styles, field),
            ),
            if (field.errorText != null)
              Container(
                alignment: Alignment.centerLeft,
                height: 18.toScale,
                child: _buildErrorText(field, styles),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MTextArea oldWidget) {
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
    _controllerNotifier.value = widget.controller;
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => hasFocus = _focus.hasFocus);

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
    FormFieldState<String?> field,
  ) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      style: styles.textStyle,
      onFieldSubmitted: widget.onFieldSubmitted,
      initialValue: widget.initialValue,
      controller: widget.controller,
      focusNode: _focus,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLength: 244,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onChanged: widget.onChanged,
      obscuringCharacter: "*",
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      cursorWidth: 1.toScale,
      cursorHeight: 18.toScale,
      decoration: InputDecoration(
        enabled: widget.enabled,
        hintText: widget.hint,
        hintStyle: styles.hintTextStyle,
        contentPadding: EdgeInsets.all($styles.insets.medium),
        counter: const SizedBox(),
        fillColor: widget.enabled ? styles.fillColor : styles.fillColorDisabled,
        filled: true,
        border: field.hasError ? styles.borderError : styles.border,
        enabledBorder: field.hasError ? styles.borderError : styles.border,
        focusedBorder:
            field.hasError ? styles.borderError : styles.borderFocused,
        disabledBorder: styles.borderDisabled,
      ),
    );
  }
}
