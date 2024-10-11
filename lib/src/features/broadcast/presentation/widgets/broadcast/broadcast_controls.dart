import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BroadcastMicrophoneButton(),
          Spaces.horizontalSmall,
          const BroadcastStartStopButton(),
          Spaces.horizontalSmall,
          BlocBuilder<BroadcastBloc, BroadcastState>(
            builder: (context, state) => state.maybeWhen(
              orElse: () => const MoreOptionsButton(),
              startSuccess: (broadcast, muted) => MoreOptionsButton(
                broadcast: broadcast,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({this.broadcast, super.key});
  final Broadcast? broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: broadcast == null
          ? null
          : () => context.showModal<void>(
                BroadcastInfoModal(broadcast: broadcast!),
                isScrollControlled: true,
              ),
    );
  }
}
