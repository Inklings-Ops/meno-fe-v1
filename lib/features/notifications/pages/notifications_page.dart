import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notifications/notifications.dart';
import 'package:meno/features/notifications/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotificationsPage extends WatchingWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<NotificationsManager>();
    return MScaffold(
      appBar: const _AppBar(),
      body: CustomScrollView(
        slivers: [_NotificationsPageView(feedSource: manager.feed)],
      ),
    );
  }
}

class _NotificationsPageView extends WatchingWidget {
  const _NotificationsPageView({required this.feedSource});

  final NotificationsFeedSource feedSource;

  @override
  Widget build(BuildContext context) {
    final grouped = watch(feedSource.groupedItems).value;
    final isFetching = watch(feedSource.isFetching).value;
    final isInitializing = !feedSource.updateWasCalled && isFetching;

    if (isInitializing) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: MLoadingIndicator.box()),
      );
    }

    if (grouped.isEmpty && feedSource.updateWasCalled) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: MenoEmptyWidget(),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverList.separated(
          separatorBuilder: (context, index) => Spaces.verticalLarge,
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            // Auto-pagination: trigger near end based on underlying flat count
            feedSource.getItemAtIndex(
              (index / grouped.length * feedSource.items.length)
                  .clamp(0, feedSource.items.length - 1)
                  .toInt(),
            );

            return switch (grouped[index]) {
              NotificationSectionHeader(:final label) => _SectionHeader(
                label: label,
              ),
              NotificationListEntry(:final proxy) => NotificationCard(
                proxy: proxy,
              ),
            };
          },
        ),
        if (!isInitializing) ...[
          SliverToBoxAdapter(
            child: MenoPagedLoadingIndicator(
              isLoading: isFetching,
              hasMore: feedSource.hasNextPage,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Padding(
      padding: const .only(top: 16),
      child: MText(label, style: textTheme.subheadingBold),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: MBackButton.withText(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: MHeader(title: 'Notifications'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86);
}
