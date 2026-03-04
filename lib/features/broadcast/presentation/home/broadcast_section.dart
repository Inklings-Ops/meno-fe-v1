import 'package:flutter/material.dart';
import 'package:meno/features/broadcast/domain/entities/broadcast.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BroadcastSection extends StatelessWidget {
  const BroadcastSection({
    required this.broadcasts,
    required this.itemBuilder,
    required this.title,
    this.onSeeAll,
    this.isLoading = false,
    this.error,
    this.onRetry,
    super.key,
  });

  final Widget title;
  final List<Broadcast?> broadcasts;
  final Widget Function(BuildContext context, Broadcast broadcast) itemBuilder;
  final VoidCallback? onSeeAll;
  final bool isLoading;
  final Object? error;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenoHeaderWidget(
          title: title,
          action: onSeeAll != null ? _buildOnSeeAllButton(context) : null,
        ),
        const SizedBox(height: 24),
        if (error != null) ...[
          MenoErrorWidget(error: error, onRetry: onRetry),
        ] else ...[
          LimitedBox(
            maxHeight: 184,
            child: _BroadcastHorizontalList(
              broadcasts: broadcasts,
              isLoading: isLoading,
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOnSeeAllButton(BuildContext context) {
    return InkWell(
      onTap: onSeeAll,
      child: MText(
        'See all',
        color: MColorScheme.of(context).onBackgroundVariant,
      ),
    );
  }
}

class _BroadcastHorizontalList extends StatelessWidget {
  const _BroadcastHorizontalList({
    required this.broadcasts,
    required this.itemBuilder,
    this.isLoading = false,
  });

  final List<Broadcast?> broadcasts;
  final bool isLoading;
  final Widget Function(BuildContext context, Broadcast broadcast) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (!isLoading && broadcasts.isEmpty) return const MenoEmptyWidget();

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: broadcasts.length,
        itemBuilder: (context, i) => itemBuilder(context, broadcasts[i]!),
        primary: false,
      ),
    );
  }
}
