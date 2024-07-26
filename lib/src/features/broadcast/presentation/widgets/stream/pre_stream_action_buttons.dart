import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class PreStreamActionButtons extends HookWidget {
  const PreStreamActionButtons({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final loading = useState<bool>(false);
    void onJoin() async {
      loading.value = true;
      return context.read<StreamBloc>().add(StreamJoinRequested(broadcast.id));
    }

    return SizedBox(
      height: 32.toScale,
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
          $styles.spaces.horizontalSmall,
          Expanded(
            child: MSecondaryButton(
              label: 'Share',
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.outlineVariant3!),
                shape: RoundedRectangleBorder(
                  borderRadius: $styles.radius.small,
                ),
                textStyle: $styles.text.microMedium,
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
    return MPrimaryButton(
      label: 'Join',
      onPressed: onJoin,
      loading: loading,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
        textStyle: $styles.text.microMedium,
      ),
    );
  }
}
