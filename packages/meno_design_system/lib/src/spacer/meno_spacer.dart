import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// {@template meno_spacer}
/// Meno Spacer
/// ```dart
///   const MenoSpacer.v(20) // gives const SizedBox(height: 20)
///   const MenoSpacer.h(20) // gives const SizedBox(width: 20)
///
/// ```
/// {@endtemplate}
class MenoSpacer extends StatelessWidget {
  /// Named private constructor for the vertical spacer factory
  const MenoSpacer._v(double value) : height = value, width = null;

  /// Named private constructor for the horizontal spacer factory
  const MenoSpacer._h(double value) : width = value, height = null;

  /// Builds the vertical space that covers the height of the given `value`.
  const factory MenoSpacer.v(double value) = MenoSpacer._v;

  /// Builds the horizontal space that covers the width of the given `value`.
  const factory MenoSpacer.h(double value) = MenoSpacer._h;

  /// The height that the space should cover
  final double? height;

  /// The width that the space should cover
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height?.h, width: width?.w);
  }
}
