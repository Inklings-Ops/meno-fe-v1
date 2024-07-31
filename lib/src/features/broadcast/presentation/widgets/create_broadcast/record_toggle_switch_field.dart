import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
class RecordToggleSwitchField extends StatelessWidget {
  const RecordToggleSwitchField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastFormCubit, BroadcastFormState>(
      buildWhen: (p, c) => p.shouldRecord != c.shouldRecord,
      builder: (context, state) => CreateBroadcastListItem(
        leadingText: 'Enable recording',
        subtitleText: 'Record your broadcast to listen back to later',
        trailing: SizedBox(
          width: 48,
          child: Switch(
            value: state.shouldRecord,
            onChanged: context.read<BroadcastFormCubit>().onRecordingChanged,
          ),
        ),
      ),
    );
  }
}
