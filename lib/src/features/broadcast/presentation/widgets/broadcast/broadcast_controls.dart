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
          BroadcastOptionsButton(),
        ],
      ),
    );
  }
}
