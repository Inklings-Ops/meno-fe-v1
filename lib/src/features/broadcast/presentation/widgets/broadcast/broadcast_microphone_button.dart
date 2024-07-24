import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastMicrophoneButton extends HookWidget {
  const BroadcastMicrophoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMuted = useState(false);
    final bloc = context.read<BroadcastBloc>();
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const MMicrophoneButton(),
        startSuccess: (broadcast, muted) => MMicrophoneButton(
          isMuted: isMuted.value,
          onTap: () {
            isMuted.value = !isMuted.value;
            bloc.add(BroadcastMuteMicrophone(!isMuted.value));
          },
        ),
      ),
    );
  }
}
