import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamActionButtons extends StatelessWidget {
  const PreStreamActionButtons({required this.broadcast, super.key});

  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    final broadcastBloc = context.watch<BroadcastBloc>();
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: MPrimaryButton(
              label: 'Join',
              loading: broadcastBloc.state.status.isLoading,
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                textStyle: textTheme.microMedium,
              ),
              onPressed: () {
                final id = broadcast.id;
                broadcastBloc.add(BroadcastJoinRequested(id));
              },
            ),
          ),
          Spaces.horizontalSmall,
          Expanded(
            child: MSecondaryButton(
              label: 'Share',
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.outlineVariant3!),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                textStyle: textTheme.microMedium,
                foregroundColor: colors.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
