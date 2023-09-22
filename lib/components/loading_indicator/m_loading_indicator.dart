import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/gen/assets.gen.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Loading Indicator 1', type: MLoadingIndicator)
MLoadingIndicator loadingIndicator1(BuildContext context) {
  return const MLoadingIndicator.one();
}

@widgetbook.UseCase(name: 'Loading Indicator 2', type: MLoadingIndicator)
MLoadingIndicator loadingIndicator2(BuildContext context) {
  return const MLoadingIndicator.two();
}

@widgetbook.UseCase(name: 'Loading Indicator 3', type: MLoadingIndicator)
MLoadingIndicator loadingIndicator3(BuildContext context) {
  return const MLoadingIndicator.three();
}

@widgetbook.UseCase(name: 'Loading Indicator 4', type: MLoadingIndicator)
MLoadingIndicator loadingIndicator4(BuildContext context) {
  return const MLoadingIndicator.four();
}

@widgetbook.UseCase(name: 'Loading Indicator 5', type: MLoadingIndicator)
MLoadingIndicator loadingIndicator5(BuildContext context) {
  return const MLoadingIndicator.five();
}

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
