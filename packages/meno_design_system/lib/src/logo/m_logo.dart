import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that displays the "Meno" logo.
///
/// This logo widget is theme-aware and will automatically switch between
/// the purple version for light mode and the white version for dark mode.
class MLogo extends StatelessWidget {
  /// Creates an instance of the Meno logo widget.
  const MLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark.
    final isLight = Theme.of(context).brightness == Brightness.light;

    // Return the appropriate logo asset based on the theme brightness.
    if (isLight) return Assets.images.menoPurple.image(height: 32.h);
    return Assets.images.menoWhite.image(height: 32.h);
  }
}
