import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BroadcastMicrophoneButton(),
          Spaces.horizontalSmall,
          BroadcastStartStopButton(),
          Spaces.horizontalSmall,
          MoreOptionsButton(),
        ],
      ),
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

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
        shape: const RoundedRectangleBorder(borderRadius: Corners.large),
      ),
      onPressed: () => context.showModal<void>(
        BlocBuilder<BroadcastBloc, BroadcastState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const SizedBox(),
            startSuccess: (b, _) => BroadcastInfoModal(broadcast: b),
          ),
        ),
        isScrollControlled: true,
      ),
    );
  }
}
