import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that displays a label for an input field, optionally with an icon.
///
/// This widget is used to create labels for input fields, such as text fields
/// or form fields.
/// It can optionally display an icon and a required indicator.
///
/// To use this widget, pass the label text and optionally provide an icon and
/// specify if the field is required.
///
/// Example usage:
/// ```dart
/// MInputLabel(
///   'Username',
///   icon: Icons.person,
///   required: true,
/// );
/// ```
class MInputLabel extends StatelessWidget {
  /// Creates an instance of [MInputLabel].
  ///
  /// Parameters:
  /// - [label]: The text to display for the label.
  /// - [key]: An optional key to identify the widget.
  /// - [icon]: An optional icon to display alongside the label.
  /// - [required]: A boolean indicating whether the field is required.
  /// Defaults to false.
  const MInputLabel(this.label, {super.key, this.icon, this.required = false});

  /// The text to display for the label.
  final String label;

  /// An optional icon to display alongside the label.
  final IconData? icon;

  /// A boolean indicating whether the field is required. Defaults to false.
  final bool required;

  @override
  Widget build(BuildContext context) {
    final styles = MTextFieldStyle.of(context);
    return SizedBox(
      height: 18.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: Insets.lg.sp, color: styles.iconColor),
            6.horizontalSpace,
          ],
          MText.caption(label, color: styles.textColor),
          if (required) ...[
            6.horizontalSpace,
            MText.caption('*', color: styles.errorColor),
          ],
        ],
      ),
    );
  }
}
