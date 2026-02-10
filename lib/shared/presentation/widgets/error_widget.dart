import 'package:flutter/material.dart';
import 'package:meno/core/core.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoErrorWidget extends StatelessWidget {
  const MenoErrorWidget({
    this.error,
    this.message,
    this.onRetry,
    super.key,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.padding = const EdgeInsets.all(16),
  }) : assert(
         error != null || message != null,
         'Either error or message must be provided',
       );

  final Object? error;
  final String? message;
  final RefreshCallback? onRetry;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    final effectiveErrorMessage = message ?? _getErrorMessage();

    return Container(
      margin: margin,
      padding: padding,
      alignment: .center,
      decoration: ShapeDecoration(
        color: colors.primaryContainer,
        shape: const RoundedSuperellipseBorder(borderRadius: Corners.lg),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.error_outline, color: colors.error),
          Spaces.verticalMedium,
          MText(
            effectiveErrorMessage,
            style: MTextTheme.of(context).captionMedium,
            textAlign: TextAlign.center,
            maxLines: 5,
          ),
          Spaces.verticalMedium,
          SizedBox(
            height: 32,
            child: MTextButton(label: 'Retry', onPressed: onRetry),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage() {
    if (error == null) return 'Unknown error';
    if (error is MenoException) return (error! as MenoException).message;
    return error.toString();
  }
}
