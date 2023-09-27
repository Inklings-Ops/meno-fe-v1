import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_decorations.dart';
import 'package:meno_design_system/src/theme/styles/m_card_styles.dart';

class MRecentlyLiveCard extends StatelessWidget {
  final String title;
  final String host;
  final String? imageUrl;

  const MRecentlyLiveCard({
    super.key,
    required this.title,
    required this.host,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final styles = MCardStyles.of(context)!;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final logoColor = isLight ? MColor.grey200 : MColor.grey30;
    final colorFilter = ColorFilter.mode(logoColor, BlendMode.srcIn);

    return Container(
      width: 176,
      height: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: styles.backgroundColor,
        boxShadow: MDecorations.cardShadow,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 148,
            height: 88,
            padding: const EdgeInsets.symmetric(vertical: 28),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: isLight ? MColor.grey30 : MColor.grey400,
              borderRadius: BorderRadius.circular(8),
            ),
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
    );
  }
}
