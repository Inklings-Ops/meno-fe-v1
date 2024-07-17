import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../../application/recently_live/recently_live_cubit.dart';
import '../../domain/domain.dart';

class RecentlyLivePage extends StatefulWidget {
  const RecentlyLivePage({super.key});

  @override
  State<RecentlyLivePage> createState() => _RecentlyLivePageState();
}

class _RecentlyLivePageState extends State<RecentlyLivePage> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecentlyLiveCubit>();
    final colorScheme = MColorScheme.of(context)!;

    return MScaffold(
      appBar: MAppBar.secondary(title: 'Recently Live', centerTitle: true),
      padding: EdgeInsets.zero,
      body: RefreshIndicator.adaptive(
        onRefresh: () async => bloc.fetch(),
        child: ListView(
          controller: scrollController,
          children: [
            BlocBuilder<RecentlyLiveCubit, RecentlyLiveState>(
              bloc: bloc,
              builder: (context, state) => state.maybeWhen(
                orElse: () => const SizedBox(),
                loading: () => const _LoadingList(),
                loadingMore: (broadcasts) => Column(
                  children: [
                    _LoadedList(broadcasts: broadcasts),
                    const Align(child: MLoadingIndicator.box()),
                  ],
                ),
                success: (broadcasts) => _LoadedList(broadcasts: broadcasts),
                successLast: (broadcasts) => Column(
                  children: [
                    _LoadedList(broadcasts: broadcasts),
                    MCore.large.verticalSpace,
                    MText(
                      'You’ve reached the end 🎉',
                      style: MTextStyle.captionRegular,
                      color: colorScheme.onBackgroundVariant,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            53.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final bloc = context.read<RecentlyLiveCubit>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        bloc.fetchMore();
      }
    });
    super.initState();
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
          title: broadcast.title.getOr(),
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
      itemCount: 5,
      itemBuilder: (context, _) => const MRecentlyLiveListTile(loading: true),
    );
  }
}
