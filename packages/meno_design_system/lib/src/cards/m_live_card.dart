import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MLiveCard extends StatelessWidget {
  const MLiveCard({
    super.key,
    required this.title,
    required this.host,
    this.imageUrl,
    this.liveCount = 0,
    this.onTap,
  });
  final String title;
  final String host;
  final String? imageUrl;
  final int? liveCount;
  final VoidCallback? onTap;

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
        clipBehavior: Clip.none,
        children: [
          _Container(
            children: [
              MAvatar(radius: 44.toScale, url: imageUrl),
              $styles.spaces.verticalMedium,
              SizedBox(
                height: 24.toScale,
                child: MText(
                  title,
                  style: styles.titleStyle,
                  color: styles.titleColor,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              $styles.spaces.verticalMicro,
              MText(
                host,
                style: styles.hostStyle,
                color: styles.hostColor,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Positioned(
            top: 8.0.toScale,
            left: 16.0.toScale,
            child: MBadge.live(count: count, showBorder: true),
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Container(
          children: [
            const MShimmer(shape: BoxShape.circle, height: 88, width: 88),
            $styles.spaces.verticalMedium,
            const MShimmer(height: 24, width: 144),
            $styles.spaces.verticalMicro,
            const MShimmer(height: 14, width: 80),
          ],
        ),
        Positioned(
          top: 8.0.toScale,
          left: 16.0.toScale,
          child: MShimmer(
            borderRadius: $styles.insets.circle,
            child: MBadge.live(count: "00K", showBorder: true),
          ),
        )
      ],
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    return Container(
      width: 176.toScale,
      height: 176.toScale,
      padding: const EdgeInsets.all(14).radius,
      decoration: ShapeDecoration(
        color: styles.backgroundColor,
        shadows: $styles.shadows.soft,
        shape: SmoothRectangleBorder(
          borderRadius: $styles.radius.squircleLarge,
        ),
      ),
      child: SizedBox(
        width: 144.toScale,
        height: 144.toScale,
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
