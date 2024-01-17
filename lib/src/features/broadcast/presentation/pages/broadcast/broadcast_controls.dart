import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/core/broadcast/meno_event.dart';
import 'package:meno_fe_v1/src/core/broadcast/meno_event_provider.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/broadcast/broadcast_notifier.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_info_modal.dart';

class BroadcastControls extends StatelessWidget {
  final Broadcast broadcast;
  const BroadcastControls({super.key, required this.broadcast});

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
          MoreOptionsButton(broadcast: broadcast),
        ],
      ),
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  final Broadcast broadcast;
  const MoreOptionsButton({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return IconButton.outlined(
      onPressed: () => context.showModal(
        BroadcastInfoModal(broadcast: broadcast, isBroadcasting: true),
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

class MuteButton extends HookConsumerWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMuted = useState(false);

    final menoEvent = ref.watch(eventProvider).event;

    if (menoEvent == const IsLiveEvent()) {
      return Microphone(
        isMuted: isMuted.value,
        onTap: () {
          isMuted.value = !isMuted.value;
          ref.read(muteProvider(!isMuted.value));
        },
      );
    }

    return const Microphone(isMuted: true);
  }
}

class Microphone extends StatelessWidget {
  final bool isMuted;

  final VoidCallback? onTap;
  const Microphone({super.key, this.isMuted = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return MIconButton(
      icon: isMuted
          ? const Icon(MIcons.microphone_off)
          : const Icon(MIcons.microphone),
      color: colorScheme.primary,
      isFilled: true,
      iconSize: 20,
      fillColor: colorScheme.primary?.withOpacity(0.1),
      onPressed: onTap,
    );
  }
}

class StartStopButton extends ConsumerWidget {
  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;
    final foregroundColor = colorScheme.onBackground;

    String label = 'Start Broadcasting';
    MColor? backgroundColor = colorScheme.primary;

    final menoEvent = ref.watch(eventProvider).event;

    if (menoEvent == const IsLiveEvent()) {
      label = 'Stop Broadcasting';
      backgroundColor = colorScheme.error;
    }

    Future<void> stop() {
      return context.showEndBroadcastDialog().then((value) {
        if (value == true) {
          ref.read(broadcastNotifierProvider.notifier).endPressed();
        }
      });
    }

    void start() => ref.read(broadcastNotifierProvider.notifier).startPressed();

    return MPrimaryButton(
      label: label,
      onPressed: menoEvent == const IsLiveEvent() ? stop : start,
      loading: ref.watch(broadcastNotifierProvider).loading,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor?.withOpacity(0.1),
        fixedSize: Size(160.w, 40.h),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).r,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(MCore.circle)).r,
        ),
      ),
    );
  }
}
