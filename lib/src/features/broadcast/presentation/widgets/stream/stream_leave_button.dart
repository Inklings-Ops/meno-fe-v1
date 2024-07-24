import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamLeaveButton extends StatelessWidget {
  const StreamLeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StreamBloc>();

    Future<void> leave(Uid<Broadcast> broadcastId) async {
      return await context.showLeaveBroadcastDialog().then((value) {
        if (value != true) return;
        bloc.add(StreamEvent.leave(broadcastId));
      });
    }

    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const _Button(),
        loading: () => const _Button(loading: true),
        joinSuccess: (broadcast) => _Button(onLeave: () => leave(broadcast.id)),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    this.onLeave,
    this.loading = false,
  });
  final bool loading;
  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return MPrimaryButton.icon(
      label: 'Leave Broadcast',
      onPressed: onLeave,
      loading: loading,
      icon: Icon(MIcons.log_out, color: colors.onErrorContainer),
      style: ElevatedButton.styleFrom(
        foregroundColor: colors.onErrorContainer,
        backgroundColor: colors.errorContainer,
        fixedSize: Size(160.toScale, 40.toScale),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).radius,
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.circle),
      ),
    );
  }
}
