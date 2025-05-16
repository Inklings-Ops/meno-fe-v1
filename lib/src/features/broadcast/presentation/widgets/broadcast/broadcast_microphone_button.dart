import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';

class BroadcastMicrophoneButton extends StatelessWidget {
  const BroadcastMicrophoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveKitBloc>();
    return BlocBuilder<LiveKitBloc, LiveKitState>(
      buildWhen: (p, c) => p.micEnabled != c.micEnabled,
      builder: (context, state) => MMicrophoneButton(
        isMicrophoneEnabled: state.micEnabled,
        onTap: () => bloc.add(const LiveKitToggleMute()),
      ),
    );
  }
}
