import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamControls extends StatelessWidget {
  const StreamControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamLeaveButton(),
          Spaces.horizontalSmall,
          StreamOptionsButton(),
        ],
      ),
    );
  }
}

class StreamOptionsButton extends StatelessWidget {
  const StreamOptionsButton({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final broadcast = context.select(
      (BroadcastBloc bloc) => bloc.state.broadcast,
    );
    return IconButton.outlined(
      icon: const Icon(MIcons.dots_horizontal),
      color: colors.onBackground,
      style: IconButton.styleFrom(
        fixedSize: const Size.fromWidth(48),
        side: BorderSide(color: colors.outlineVariant3!),
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
      ),
      onPressed: () => context.showModal<void>(
        BroadcastInfoModal(broadcast: broadcast, isStreaming: true),
        isScrollControlled: true,
      ),
    );
  }
}
