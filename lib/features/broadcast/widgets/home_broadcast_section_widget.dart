import 'package:flutter/material.dart';
import 'package:meno/_shared/widgets/meno_header_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class HomeBroadcastSectionWidget extends StatelessWidget {
  const HomeBroadcastSectionWidget({
    required this.title,
    required this.builder,
    super.key,
    this.onSeeAll,
    this.maxContentHeight = 184.0,
  });

  final Widget title;
  final Widget Function(BuildContext context) builder;
  final VoidCallback? onSeeAll;
  final double maxContentHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        MenoHeaderWidget(title: title, action: _buildOnSeeAllButton(context)),
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
