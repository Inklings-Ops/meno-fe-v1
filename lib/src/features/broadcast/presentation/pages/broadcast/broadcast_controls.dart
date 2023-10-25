import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/pages/broadcast/broadcaster_info_modal.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../services/live_kit_service.dart';
import '../../../../../services/socket_service/socket_service.dart';
import '../../../application/broadcast/broadcast_notifier.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MuteButton(),
          MSize.horizontalSpaceSmall,
          const StartStopButton(),
          MSize.horizontalSpaceSmall,
          IconButton.outlined(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => const BroadcasterInfoModal(),
            ),
            icon: const Icon(MIcons.dots_horizontal),
            color: colorScheme.onBackground,
            style: IconButton.styleFrom(
              fixedSize: const Size.fromWidth(48),
              side: BorderSide(color: colorScheme.outlineVariant3!),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(MCore.large)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MuteButton extends HookConsumerWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    final isMuted = useState(false);

    final Status status = ref.watch(broadcastStatusProvider);
    final bool isLive = status == Status.live;

    return MIconButton(
      icon: isMuted.value ? MIcons.microphone_off : MIcons.microphone,
      color: colorScheme.primary,
      isFilled: true,
      fillColor: colorScheme.primary?.withOpacity(0.1),
      onPressed: !isLive
          ? null
          : () async {
              isMuted.value = !isMuted.value;
              await ref
                  .read(liveKitNotifierProvider.notifier)
                  .setMute(isMuted.value);
            },
    );
  }
}

class StartStopButton extends ConsumerWidget {
  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;
    final MColor? foregroundColor = colorScheme.onBackground;

    String label = "Start Broadcasting";
    MColor? backgroundColor = colorScheme.primary;

    final isLive = ref.watch(socketProvider).value.isLive;

    if (isLive) {
      label = "Stop Broadcasting";
      backgroundColor = colorScheme.error;
    }

    Future<void> stop() {
      return context.showEndBroadcastAlert().then((value) {
        if (value == true) {
          ref.read(broadcastNotifierProvider.notifier).endPressed();
          context.go(Routes.layout);
        }
      });
    }

    void start() => ref.read(broadcastNotifierProvider.notifier).startPressed();

    return MPrimaryButton(
      label: label,
      onPressed: isLive ? stop : start,
      loading: ref.watch(broadcastNotifierProvider).loading,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor?.withOpacity(0.1),
        fixedSize: const Size(160, 40),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MCore.circle)),
        ),
      ),
    );
  }
}
