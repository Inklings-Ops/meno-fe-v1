import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamTab extends HookWidget {
  const StreamTab({super.key});
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16).r,
          child: Column(
            children: [
              const _StreamArtwork(),
              MCore.small.verticalSpace,
              const BroadcastTimer(),
              MCore.small.verticalSpace,
              const _StreamTitle(),
              MCore.small.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _CreatorName(),
                  MCore.small.horizontalSpace,
                  const BroadcastStatusWidget(isStreaming: true),
                ],
              ),
              24.verticalSpace,
              const StreamControls(),
              MCore.large.verticalSpace,
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0).r,
                constraints: const BoxConstraints(maxHeight: 32).r,
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
                    BroadcastListeningTab(),
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

class _StreamArtwork extends StatelessWidget {
  const _StreamArtwork();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(joinSuccess: (b) => b.imageUrl),
      builder: (context, url) => BroadcastArtworkWidget(imageUrl: url),
    );
  }
}

class _StreamTitle extends StatelessWidget {
  const _StreamTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        joinSuccess: (broadcast) => broadcast.title.getOr(),
      ),
      builder: (context, title) => BroadcastTitle(title: title),
    );
  }
}

class _CreatorName extends StatelessWidget {
  const _CreatorName();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        joinSuccess: (b) => b.creator!.fullName,
      ),
      builder: (context, fullName) => MText(
        fullName,
        style: MTextStyle.captionRegular,
      ),
    );
  }
}

class _BroadcastAboutTab extends StatelessWidget {
  const _BroadcastAboutTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(
        joinSuccess: (broadcast) => broadcast.description?.getOr(),
      ),
      builder: (context, desc) => BroadcastAboutTab(description: desc),
    );
  }
}
