import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/broadcast/broadcast_bloc.dart';
import '../../widgets/broadcast_about_tab.dart';
import '../../widgets/broadcast_artwork.dart';
import '../../widgets/broadcast_listening_tab.dart';
import '../../widgets/broadcast_status_widget.dart';
import '../../widgets/broadcast_title.dart';
import 'broadcast_controls.dart';
import 'broadcast_timer.dart';

class BroadcastTab extends HookWidget {
  const BroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Column(
      children: [
        Container(
          height: 356.h,
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
        Expanded(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0).r,
                constraints: const BoxConstraints(maxHeight: 32).r,
                child: TabBar.secondary(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'Listening'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
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
      selector: (state) => state.broadcast.description?.get(),
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
      selector: (state) => state.broadcast.imageUrl,
      builder: (context, imageUrl) => BroadcastArtwork(imageUrl: imageUrl),
    );
  }
}

class _BroadcastCreator extends StatelessWidget {
  const _BroadcastCreator();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      bloc: context.read<BroadcastBloc>(),
      selector: (state) => state.broadcast.creator!.fullName,
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
      builder: (context, state) => BroadcastListeningTab(
        broadcast: state.broadcast,
      ),
    );
  }
}

class _BroadcastTitle extends StatelessWidget {
  const _BroadcastTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      bloc: context.read<BroadcastBloc>(),
      selector: (state) => state.broadcast.title.get()!,
      builder: (context, title) => BroadcastTitle(title: title),
    );
  }
}
