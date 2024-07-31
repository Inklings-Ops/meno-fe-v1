import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamActionButtons extends HookWidget {
  const PreStreamActionButtons({required this.broadcast, super.key});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final loading = useState<bool>(false);
    Future<void> onJoin() async {
      loading.value = true;
      return context.read<StreamBloc>().add(StreamJoinRequested(broadcast.id));
    }

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: BlocListener<StreamBloc, StreamState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () => loading.value = false,
                  loading: () => loading.value,
                );
              },
              child: _JoinButton(onJoin: onJoin, loading: loading.value),
            ),
          ),
          Spaces.horizontalSmall,
          Expanded(
            child: MSecondaryButton(
              label: 'Share',
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.outlineVariant3!),
                shape: const RoundedRectangleBorder(
                  borderRadius: Corners.small,
                ),
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

class _JoinButton extends StatelessWidget {
  const _JoinButton({this.onJoin, this.loading = false});
  final bool loading;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return MPrimaryButton(
      label: 'Join',
      onPressed: onJoin,
      loading: loading,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: Corners.small),
        textStyle: textTheme.microMedium,
      ),
    );
  }
}
