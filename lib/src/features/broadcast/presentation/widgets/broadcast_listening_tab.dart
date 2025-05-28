import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastListeningTab extends StatelessWidget {
  const BroadcastListeningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('BroadcastListeningTab'),
      children: [
        MenoSpacer.v(Insets.xl),
        ParticipantListHeaderWidget(),
        MenoSpacer.v(Insets.lg),
        Expanded(child: ParticipantList()),
      ],
    );
  }
}
