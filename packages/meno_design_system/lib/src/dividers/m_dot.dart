import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MDot extends StatelessWidget {
  const MDot({super.key, this.dimension = 4, this.color});
  final double dimension;
  final MColor? color;

  @override
  Widget build(BuildContext context) => Container(
        width: dimension.toScale,
        height: dimension.toScale,
        decoration: const BoxDecoration(
          color: MColor.grey500,
          shape: BoxShape.circle,
        ),
      );
}
