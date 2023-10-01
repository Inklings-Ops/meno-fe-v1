import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoLogo extends StatelessWidget {
  const MenoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    if (isLight) {
      return Assets.images.menoPurple.image(height: 32);
    } else {
      return Assets.images.menoWhite.image(height: 32);
    }
  }
}
