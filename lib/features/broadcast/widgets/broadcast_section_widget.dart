import 'package:flutter/material.dart';
import 'package:meno/_shared/widgets/meno_header_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastSectionWidget extends StatelessWidget {
  const BroadcastSectionWidget({
    required this.title,
    required this.builder,
    super.key,
    this.titleIcon,
    this.onSeeAll,
    this.maxContentHeight = 184.0,
    this.padding,
  });

  final String title;
  final Widget? titleIcon;
  final Widget Function(BuildContext context) builder;
  final VoidCallback? onSeeAll;
  final double maxContentHeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MenoHeaderWidget(
          title: Row(
            children: [
              MText(title),
              if (titleIcon != null) ...[Spaces.horizontalSmall, titleIcon!],
            ],
          ),
          action: _buildOnSeeAllButton(context),
          padding: padding,
        ),
        const SizedBox(height: 24),
        LimitedBox(maxHeight: maxContentHeight, child: builder(context)),
      ],
    );
  }

  Widget _buildOnSeeAllButton(BuildContext context) {
    if (onSeeAll == null) return const SizedBox.shrink();

    final colors = MColorScheme.of(context);
    return InkWell(
      onTap: onSeeAll,
      child: MText('See all', color: colors.onBackgroundVariant),
    );
  }
}
