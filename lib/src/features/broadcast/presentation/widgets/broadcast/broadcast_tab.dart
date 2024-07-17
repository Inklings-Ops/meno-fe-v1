import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTab extends HookWidget {
  const BroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Column(
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _BroadcastArtwork(),
                MCore.small.verticalSpace,
                const BroadcastTimer(),
                MCore.small.verticalSpace,
                const _BroadcastTitle(),
                MCore.small.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _BroadcastCreator(),
                    MCore.small.horizontalSpace,
                    const BroadcastStatusWidget(),
                  ],
                ),
                24.verticalSpace,
                const BroadcastControls(),
                MCore.large.verticalSpace,
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 40.h,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0).r,
                child: TabBar.secondary(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'Listening'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
              24.verticalSpace,
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    _BroadcastListeningTab(),
                    _BroadcastAboutTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BroadcastAboutTab extends StatelessWidget {
  const _BroadcastAboutTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String?>(
      selector: (state) => state.maybeWhen(
        orElse: () => null,
        startSuccess: (broadcast, muted) => broadcast.description?.getOr(),
      ),
      builder: (context, desc) => BroadcastAboutTab(description: desc),
    );
  }
}

class _BroadcastArtwork extends StatelessWidget {
  const _BroadcastArtwork();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String?>(
      bloc: context.read<BroadcastBloc>(),
      selector: (state) => state.maybeWhen(
        orElse: () => null,
        startSuccess: (broadcast, muted) => broadcast.imageUrl,
      ),
      builder: (context, url) => BroadcastArtworkWidget(imageUrl: url),
    );
  }
}

class _BroadcastCreator extends StatelessWidget {
  const _BroadcastCreator();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      bloc: context.read<BroadcastBloc>(),
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        startSuccess: (broadcast, muted) => broadcast.creator!.fullName,
      ),
      builder: (context, fullName) => MText(
        fullName,
        style: MTextStyle.captionRegular,
        color: MColorScheme.of(context)!.onDisabledContainer,
      ),
    );
  }
}

class _BroadcastListeningTab extends StatelessWidget {
  const _BroadcastListeningTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const MLoadingIndicator.box(),
        startSuccess: (broadcast, mute) => const BroadcastListeningTab(),
      ),
    );
  }
}

class _BroadcastTitle extends StatelessWidget {
  const _BroadcastTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        startSuccess: (broadcast, muted) => broadcast.title.getOr(),
      ),
      builder: (context, title) => BroadcastTitle(title: title),
    );
  }
}
