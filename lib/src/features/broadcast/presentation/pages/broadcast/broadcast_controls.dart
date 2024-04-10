import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../services/meno/meno_bloc.dart';
import '../../../application/broadcast/broadcast_bloc.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_info_modal.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MuteButton(),
          MCore.small.horizontalSpace,
          const StartStopButton(),
          MCore.small.horizontalSpace,
          const MoreOptionsButton(),
        ],
      ),
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return IconButton.outlined(
      onPressed: () => context.showModal(
        BlocSelector<BroadcastBloc, BroadcastState, Broadcast>(
          selector: (state) => state.broadcast,
          builder: (context, state) => BroadcastInfoModal(broadcast: state),
        ),
        isScrollControlled: true,
      ),
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colorScheme.onBackground,
      style: IconButton.styleFrom(
        fixedSize: Size.fromWidth(48.r),
        side: BorderSide(color: colorScheme.outlineVariant3!),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MCore.large)),
        ),
      ),
    );
  }
}

class MuteButton extends HookWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMuted = useState(false);

    final bloc = context.read<BroadcastBloc>();

    return BlocBuilder<MenoBloc, MenoState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const MMicrophoneButton(),
        live: (_) => BlocBuilder<BroadcastBloc, BroadcastState>(
          bloc: bloc,
          buildWhen: (p, c) => p.isMuted != c.isMuted,
          builder: (context, state) => MMicrophoneButton(
            isMuted: isMuted.value,
            onTap: () {
              isMuted.value = !isMuted.value;
              bloc.add(BroadcastEvent.mute(!isMuted.value));
            },
          ),
        ),
      ),
    );
  }
}

class StartStopButton extends HookWidget {
  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final label = useState('Start broadcasting');
    final backgroundColor = useState(colorScheme.primary);

    final broadcastBloc = context.read<BroadcastBloc>();

    Future<void> stop() {
      return context.showEndBroadcastDialog().then((value) {
        if (value != true) return;
        return broadcastBloc.add(const BroadcastEvent.end());
      });
    }

    void start() => broadcastBloc.add(const BroadcastEvent.start());

    return BlocConsumer<MenoBloc, MenoState>(
      listener: (context, state) {
        state.whenOrNull(
          live: (broadcast) {
            label.value = 'Stop Broadcasting';
            backgroundColor.value = colorScheme.error;
          },
        );
      },
      builder: (context, mState) {
        final isLive = mState is MLive;

        return BlocBuilder<BroadcastBloc, BroadcastState>(
          bloc: broadcastBloc,
          buildWhen: (p, c) => p.loading != c.loading,
          builder: (context, state) => MPrimaryButton(
            label: label.value,
            onPressed: isLive ? stop : start,
            loading: state.loading,
            style: ElevatedButton.styleFrom(
              foregroundColor: colorScheme.onBackground,
              backgroundColor: backgroundColor.value?.withOpacity(0.1),
              fixedSize: Size(160.w, 40.h),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).r,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(MCore.circle),
                ).r,
              ),
            ),
          ),
        );
      },
    );
  }
}
