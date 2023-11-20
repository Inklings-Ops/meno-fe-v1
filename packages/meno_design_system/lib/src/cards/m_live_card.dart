import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_decorations.dart';

import '../m_size.dart';

class MLiveCard extends StatelessWidget {
  final String title;
  final String host;
  final String? imageUrl;
  final int? liveCount;
  final VoidCallback? onTap;

  const MLiveCard({
    super.key,
    required this.title,
    required this.host,
    this.imageUrl,
    this.liveCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final MCardStyles styles = MCardStyles.of(context)!;

    String? count;

    if (liveCount != null && liveCount != 0) {
      count = NumberFormat.compactCurrency(
        decimalDigits: 0,
        symbol: "",
      ).format(liveCount);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _Container(
            children: [
              MAvatar(radius: 44, url: imageUrl),
              MSize.verticalSpaceMedium,
              MText(
                title,
                style: styles.titleStyle,
                color: styles.titleColor,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              MSize.verticalSpaceMicro,
              MText(
                host,
                style: styles.hostStyle,
                color: styles.hostColor,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Positioned(
            left: 10.0,
            top: 8.0,
            child: MBadge.live(count: count),
          )
        ],
      ),
    );
  }
}

class MLiveCardSkeleton extends StatelessWidget {
  const MLiveCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _Container(
          children: [
            MShimmer(shape: BoxShape.circle, height: 88, width: 88),
            MSize.verticalSpaceMedium,
            MShimmer(height: 24),
            MSize.verticalSpaceMicro,
            MShimmer(height: 14, width: 80),
          ],
        ),
        Positioned(
          left: 10.0,
          top: 8.0,
          child: MShimmer(child: MBadge.live()),
        )
      ],
    );
  }
}

class _Container extends StatelessWidget {
  final List<Widget> children;
  const _Container({required this.children});

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;

    return Container(
      padding: const EdgeInsets.all(MCore.large),
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        boxShadow: MDecorations.cardShadow,
        borderRadius: const BorderRadius.all(
          Radius.circular(MCore.large),
        ),
      ),
      child: SizedBox(
        width: 144,
        height: 176,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
