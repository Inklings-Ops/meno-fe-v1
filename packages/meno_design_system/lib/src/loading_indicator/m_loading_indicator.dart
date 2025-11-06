import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that displays a loading indicator with various predefined sizes.
///
/// This widget provides multiple constructors to create loading indicators with
/// different predefined sizes. It also supports custom sizes through the
/// [MLoadingIndicator.box] constructor.
///
/// Example usage:
/// ```dart
/// // Using a predefined size:
/// const MLoadingIndicator.five();
///
/// // Using a custom size:
/// const MLoadingIndicator.box(height: 50, width: 50);
/// ```
class MLoadingIndicator extends StatelessWidget {
  /// Creates an instance of [MLoadingIndicator] with the specified height and
  /// width.
  ///
  /// This constructor is used internally by the various named constructors.
  const MLoadingIndicator(this.height, this.width, {super.key});

  /// Internal constructor used by named constructors.
  const MLoadingIndicator._(this.height, this.width, {super.key});

  /// Creates an instance of [MLoadingIndicator] with a predefined size of
  /// 48x48.
  const MLoadingIndicator.five({
    Key? key,
    double height = 48,
    double width = 48,
  }) : this._(height, width, key: key);

  /// Creates an instance of [MLoadingIndicator] with a predefined size of
  /// 40x40.
  const MLoadingIndicator.four({
    Key? key,
    double height = 40,
    double width = 40,
  }) : this._(height, width, key: key);

  /// Creates an instance of [MLoadingIndicator] with a predefined size of
  /// 1200x1200.
  const MLoadingIndicator.one({
    Key? key,
    double height = 1200,
    double width = 1200,
  }) : this._(height, width, key: key);

  /// Creates an instance of [MLoadingIndicator] with a predefined size of
  /// 32x32.
  const MLoadingIndicator.three({
    Key? key,
    double height = 32,
    double width = 32,
  }) : this._(height, width, key: key);

  /// Creates an instance of [MLoadingIndicator] with a predefined size of
  /// 24x24.
  const MLoadingIndicator.two({Key? key, double height = 24, double width = 24})
    : this._(height, width, key: key);

  /// Factory constructor to create an instance of [MLoadingIndicator] with
  /// custom size.
  ///
  /// Parameters:
  /// - [height]: The height of the loading indicator. Defaults to null.
  /// - [width]: The width of the loading indicator. Defaults to null.
  const factory MLoadingIndicator.box({
    Key? key,
    double? height,
    double? width,
  }) = _BoxLoadingIndicator;

  /// The height of the loading indicator.
  final double? height;

  /// The width of the loading indicator.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height?.r,
      width: width?.r,
      child: Assets.images.loading.image(fit: BoxFit.cover),
    );
  }
}

/// A private class that implements the [MLoadingIndicator.box] constructor.
///
/// This class is used to create a loading indicator with custom size.
class _BoxLoadingIndicator extends MLoadingIndicator {
  const _BoxLoadingIndicator({Key? key, double? height, double? width})
    : super._(height, width, key: key);

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final dimension = MediaQuery.sizeOf(context).width * 0.2;
    return Center(
      child: Container(
        height: (height ?? dimension).r,
        width: (width ?? dimension).r,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: Corners.md.r,
        ),
        child: Assets.images.loading.image(),
      ),
    );
  }
}
