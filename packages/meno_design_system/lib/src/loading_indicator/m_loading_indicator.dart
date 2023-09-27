import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MLoadingIndicator extends StatelessWidget {
  final double height;
  final double width;

  /// Creates a 'default' sized loading indicator.
  const MLoadingIndicator({Key? key}) : this.five(key: key);

  /// Creates a custom loading indicator.
  const MLoadingIndicator.custom(this.height, this.width, {super.key});

  const MLoadingIndicator.five({
    Key? key,
    double height = 48,
    double width = 48,
  }) : this.custom(height, width, key: key);

  const MLoadingIndicator.four({
    Key? key,
    double height = 40,
    double width = 40,
  }) : this.custom(height, width, key: key);

  const MLoadingIndicator.one({
    Key? key,
    double height = 1200,
    double width = 1200,
  }) : this.custom(height, width, key: key);

  const MLoadingIndicator.three({
    Key? key,
    double height = 32,
    double width = 32,
  }) : this.custom(height, width, key: key);

  const MLoadingIndicator.two({
    Key? key,
    double height = 24,
    double width = 24,
  }) : this.custom(height, width, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Assets.images.loading.image(fit: BoxFit.cover),
    );
  }
}
