import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_decorations.dart';
import 'package:meno_design_system/src/theme/styles/m_card_styles.dart';

class MLiveCard extends StatelessWidget {
  final String title;
  final String host;
  final String? imageUrl;
  final int liveCount;

  const MLiveCard({
    super.key,
    required this.title,
    required this.host,
    this.imageUrl,
    this.liveCount = 220,
  });

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final logoColor = isLight ? MColor.grey200 : MColor.grey30;
    final colorFilter = ColorFilter.mode(logoColor, BlendMode.srcIn);

    final String? count = liveCount == 0 ? null : liveCount.toString();

    return Stack(
      children: [
        Container(
          width: 176,
          height: 206,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: styles.backgroundColor,
            boxShadow: MDecorations.cardShadow,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44.0,
                backgroundColor: isLight ? MColor.grey30 : MColor.grey400,
                foregroundImage:
                    imageUrl != null ? NetworkImage(imageUrl!) : null,
                child: Assets.images.logoLight.svg(
                  colorFilter: colorFilter,
                  height: 32.0,
                ),
              ),
              const SizedBox(height: 12),
              MText(title, style: styles.titleStyle, color: styles.titleColor),
              const SizedBox(height: 4),
              MText(host, style: styles.hostStyle, color: styles.hostColor),
            ],
          ),
        ),
        Positioned(
          left: 10.0,
          top: 8.0,
          child: MBadge.live(count: count),
        )
      ],
    );
  }
}
