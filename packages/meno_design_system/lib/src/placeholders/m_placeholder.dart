import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

/// A placeholder widget that displays a logo based on the theme.
///
/// This widget is useful for displaying a placeholder image while content is
/// loading.
class MPlaceholder extends StatelessWidget {
  /// Creates a new `MPlaceholder` widget.
  ///
  /// * `dimension`: The size of the placeholder. If null, the placeholder
  /// will adapt to its parent's size.
  const MPlaceholder({super.key, this.dimension});

  /// The size of the placeholder.
  final double? dimension;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return SizedBox.square(
      dimension: dimension?.r,
      child: isLight
          ? Assets.images.logoDark.svg()
          : Assets.images.logoLight.svg(),
    );
  }
}
