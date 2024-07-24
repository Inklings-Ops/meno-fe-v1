import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/gen/assets.gen.dart';

class MLoadingIndicator extends StatelessWidget {
  final double? height;
  final double? width;

  /// Creates a custom loading indicator.
  const MLoadingIndicator._(this.height, this.width, {super.key});

  const MLoadingIndicator(this.height, this.width, {super.key});

  const MLoadingIndicator.five({
    Key? key,
    double height = 48,
    double width = 48,
  }) : this._(height, width, key: key);

  const MLoadingIndicator.four({
    Key? key,
    double height = 40,
    double width = 40,
  }) : this._(height, width, key: key);

  const MLoadingIndicator.one({
    Key? key,
    double height = 1200,
    double width = 1200,
  }) : this._(height, width, key: key);

  const MLoadingIndicator.three({
    Key? key,
    double height = 32,
    double width = 32,
  }) : this._(height, width, key: key);

  const MLoadingIndicator.two({
    Key? key,
    double height = 24,
    double width = 24,
  }) : this._(height, width, key: key);

  const factory MLoadingIndicator.box({
    Key? key,
    double? height,
    double? width,
  }) = _BoxLoadingIndicator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height?.toScale,
      width: width?.toScale,
      child: Assets.images.loading.image(fit: BoxFit.cover),
    );
  }
}

class _BoxLoadingIndicator extends MLoadingIndicator {
  const _BoxLoadingIndicator({
    Key? key,
    double? height,
    double? width,
  }) : super._(height, width, key: key);

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final dimension = MediaQuery.sizeOf(context).width * 0.2;
    return Center(
      child: Container(
        height: height ?? dimension,
        width: width ?? dimension,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: $styles.radius.medium,
        ),
        child: Assets.images.loading.image(),
      ),
    );
  }
}
