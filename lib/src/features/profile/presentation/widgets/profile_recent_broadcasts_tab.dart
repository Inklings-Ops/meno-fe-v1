import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast_list/broadcast_list_provider.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/domain.dart';
import 'package:meno_fe_v1/src/router/router.dart';

import 'empty_state_widget.dart';

class ProfileRecentBroadcastsTab extends ConsumerWidget {
  const ProfileRecentBroadcastsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcasts = ref.watch(myRecentBroadcastsProvider(limit: 8));

    Logger().w(broadcasts);

    if (broadcasts.isLoading) {
      return const _LoadingList();
    }

    if (broadcasts.hasError && !broadcasts.isLoading) {
      return Container(
        margin: const EdgeInsets.only(top: 40).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 40.r),
            const MText(
              'Reload ',
              style: MTextStyle.captionMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (broadcasts.hasValue && broadcasts.value!.isEmpty) {
      return EmptyStateWidget(actionTitle: 'Broadcasts', action: () {});
    }

    return _LoadedList(broadcasts: broadcasts.value!);
  }
}

class _BuildListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const _BuildListView({
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24).r,
      separatorBuilder: (context, index) => MCore.large.verticalSpace,
    );
  }
}

class _LoadedList extends StatelessWidget {
  final List<Broadcast?> broadcasts;
  const _LoadedList({required this.broadcasts});

  @override
  Widget build(BuildContext context) {
    return _BuildListView(
      itemCount: broadcasts.length,
      itemBuilder: (context, index) {
        final broadcast = broadcasts[index]!;
        return MRecentlyLiveListTile(
          title: broadcast.title.get(),
          creator: broadcast.fullName,
          endTime: broadcast.endTime,
          imageUrl: broadcast.imageUrl,
          onTap: () => context.push(Routes.details, extra: broadcast),
        );
      },
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return _BuildListView(
      itemCount: 2,
      itemBuilder: (context, _) => const MRecentlyLiveListTile(loading: true),
    );
  }
}
