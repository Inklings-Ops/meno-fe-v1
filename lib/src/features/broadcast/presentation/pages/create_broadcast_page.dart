import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';


class CreateBroadcastPage extends HookWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final colors = MColorScheme.of(context)!;
    final broadcastBloc = context.read<BroadcastBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<BroadcastFormCubit, BroadcastFormState>(
          listener: (context, state) {
            state.option.fold(
              () => null,
              (either) => either.fold(
                (exception) => context.showBroadcastError(exception),
                (b) => broadcastBloc.add(BroadcastStartRequested(b.id)),
              ),
            );
          },
        ),
        BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (exception) => context.showBroadcastError(exception),
              startFailed: (e) => context.showErrorSnackBar(e.toString()),
              startSuccess: (broadcast, muted) {
                router.replace<void>(Routes.broadcast, extra: broadcast);
              },
            );
          },
        ),
      ],
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: MScaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            leadingWidth: 0,
            title: const MHeader(
              title: 'Go Live Now',
              padding: EdgeInsets.zero,
            ),
            actions: [
              InkWell(
                onTap: context.pop,
                child: MText('Cancel', color: colors.onBackgroundVariant),
              ),
              Spaces.horizontalLarge,
            ],
          ),
          body: const SingleChildScrollView(child: CreateBroadcastForm()),
          persistentFooterButtons: const [CreateBroadcastButton()],
        ),
      ),
    );
  }
}
