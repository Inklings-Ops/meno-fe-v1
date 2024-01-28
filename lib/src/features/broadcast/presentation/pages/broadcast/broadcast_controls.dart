import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BroadcastBloc>();

    return BlocBuilder<MenoBloc, MenoState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const MMicrophoneButton(),
        live: () => BlocSelector<BroadcastBloc, BroadcastState, bool>(
          selector: (state) => state.isMute,
          builder: (context, isMute) => MMicrophoneButton(
            isMuted: isMute,
            onTap: () => bloc.add(BroadcastEvent.mute(!isMute)),
          ),
        ),
      ),
    );
  }
}

class StartStopButton extends StatelessWidget {
  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcastBloc = context.read<BroadcastBloc>();

    final colorScheme = MColorScheme.of(context)!;
    final foregroundColor = colorScheme.onBackground;

    final baseButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: colorScheme.primary?.withOpacity(0.1),
      fixedSize: Size(160.w, 40.h),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).r,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(MCore.circle)).r,
      ),
    );

    final stopButtonStyle = baseButtonStyle.copyWith(
      backgroundColor: MaterialStatePropertyAll(colorScheme.error),
    );

    Future<void> stop() {
      return context.showEndBroadcastDialog().then((value) {
        if (value != true) return;
        return broadcastBloc.add(const BroadcastEvent.start());
      });
    }

    return BlocBuilder<MenoBloc, MenoState>(
      bloc: context.watch<MenoBloc>(),
      builder: (context, state) => state.maybeWhen(
        orElse: () => MPrimaryButton(
          label: 'Start Broadcasting',
          onPressed: () => broadcastBloc.add(const BroadcastEvent.start()),
          style: baseButtonStyle,
        ),
        live: () => BlocSelector<BroadcastBloc, BroadcastState, bool>(
          bloc: broadcastBloc,
          selector: (state) => state.loading,
          builder: (context, loading) => MPrimaryButton(
            label: 'Stop Broadcasting',
            onPressed: stop,
            loading: loading,
            style: stopButtonStyle,
          ),
        ),
      ),
    );
  }
}
