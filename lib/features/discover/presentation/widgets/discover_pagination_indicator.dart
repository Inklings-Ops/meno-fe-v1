import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DiscoverPaginationIndicator extends StatelessWidget {
  const DiscoverPaginationIndicator({
    required this.isLoading, required this.hasMore, super.key,
  });
  final bool isLoading;
  final bool hasMore;
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Column(
      children: [
        if (isLoading) const MLoadingIndicator.box(),
        if (!isLoading && !hasMore)
          MText(
            'You’ve reached the end 🎉',
            style: textTheme.captionRegular,
            color: colors.onBackgroundVariant,
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 28),
      ],
    );
  }
}
