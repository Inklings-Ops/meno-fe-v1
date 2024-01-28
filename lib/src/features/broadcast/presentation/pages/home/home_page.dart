import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../services/meno/meno_bloc.dart';
import '../../../application/live_broadcasts/live_broadcasts_bloc.dart';
import '../../../application/recently_live/recently_live_cubit.dart';
import 'home_app_bar.dart';
import 'live_activity_card.dart';
import 'live_for_you.dart';
import 'now_live.dart';
import 'recently_live.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final recentlyLiveBloc = context.read<RecentlyLiveCubit>();
    final liveBroadcastsCubit = context.read<LiveBroadcastsBloc>();

    Future<void> onRefresh() async {
      Future liveBroadcasts = liveBroadcastsCubit.stream.first;
      liveBroadcastsCubit.add(const LiveBroadcastsEvent.getLiveBroadcasts());

      Future recentlyLive = recentlyLiveBloc.stream.first;
      recentlyLiveBloc.fetch();

      await Future.wait([liveBroadcasts, recentlyLive]);
    }

    return MScaffold(
      appBar: const HomeAppBar(),
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              24.verticalSpace,
              BlocBuilder<MenoBloc, MenoState>(
                builder: (context, state) => state.maybeWhen(
                  orElse: () => const SizedBox(),
                  streaming: () => Padding(
                    padding: const EdgeInsets.only(bottom: MCore.xxLarge).r,
                    child: const LiveActivityCard(),
                  ),
                ),
              ),
              const LiveForYou(),
              const NowLive(),
              const RecentlyLive(),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
