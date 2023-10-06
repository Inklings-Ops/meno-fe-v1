import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

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
      height: height,
      width: width,
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
    final MColorScheme colorScheme = MColorScheme.of(context)!;
    return Center(
      child: Container(
        height: height ?? MediaQuery.sizeOf(context).width * 0.2,
        width: width ?? MediaQuery.sizeOf(context).width * 0.2,
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Assets.images.loading.image(),
      ),
    );
  }
}
