import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.toScale,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BroadcastMicrophoneButton(),
          $styles.spaces.horizontalSmall,
          const BroadcastStartStopButton(),
          $styles.spaces.horizontalSmall,
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
    final colors = MColorScheme.of(context)!;
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      iconSize: 20.toScale,
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: Size.fromWidth(48.toScale),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.large),
      ),
      onPressed: () => context.showModal(
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
