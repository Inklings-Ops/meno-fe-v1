import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverPaginationIndicator extends StatelessWidget {
  const DiscoverPaginationIndicator({
    super.key,
    required this.isLoading,
    required this.hasMore,
  });
  final bool isLoading;
  final bool hasMore;
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Column(
      children: [
        if (isLoading) const MLoadingIndicator.box(),
        if (!isLoading && !hasMore)
          MText(
            'You’ve reached the end 🎉',
            style: $styles.text.captionRegular,
            color: colors.onBackgroundVariant,
            textAlign: TextAlign.center,
          ),
        28.vSpace,
      ],
    );
  }
}
