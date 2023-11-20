import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../application/broadcast_list/broadcast_list_provider.dart';
import '../../../domain/domain.dart';

class RecentlyLivePage extends ConsumerWidget {
  const RecentlyLivePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final broadcasts = ref.watch(recentBroadcastsProvider());

    return MScaffold(
      appBar: MAppBar.secondary(title: "Recently Live", centerTitle: true),
      padding: EdgeInsets.zero,
      body: RefreshIndicator.adaptive(
        onRefresh: () async => await ref.refresh(recentBroadcastsProvider()),
        child: ListView(
          children: [
            if (broadcasts.isLoading)
              const _LoadingList()
            else if (broadcasts.hasValue)
              _LoadedList(broadcasts: broadcasts.value!),
            MCore.large.verticalSpace,
            MText(
              "You’ve reached the end 🎉",
              style: MTextStyle.captionRegular,
              color: colorScheme.onBackgroundVariant,
              textAlign: TextAlign.center,
            ),
            53.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _BuildListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const _BuildListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
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
  const _LoadedList({Key? key, required this.broadcasts}) : super(key: key);

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
  const _LoadingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BuildListView(
      itemCount: 5,
      itemBuilder: (context, _) => const MRecentlyLiveListTile(loading: true),
    );
  }
}
