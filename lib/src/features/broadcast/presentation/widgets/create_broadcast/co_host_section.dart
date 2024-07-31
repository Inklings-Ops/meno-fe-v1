import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class CoHostSection extends StatelessWidget {
  const CoHostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 72,
      child: Row(
        children: [
          ParticipantItem(
            onTap: () => context.showModal<void>(
              const AddCohostModal(),
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.9,
              ),
            ),
          ),
          Spaces.horizontalSmall,
          const Wrap(
            spacing: 8,
          ),
        ],
      ),
    );
  }
}
