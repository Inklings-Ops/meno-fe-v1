import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MDot extends StatelessWidget {
  final double? dimension;
  final MColor? color;

  const MDot({super.key, this.dimension = 4, this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: dimension,
        height: dimension,
        decoration: const BoxDecoration(
          color: MColor.grey500,
          shape: BoxShape.circle,
        ),
      );
}
