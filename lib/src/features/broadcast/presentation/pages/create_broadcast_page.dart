import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/live_kit/bloc/live_kit_bloc.dart';
import 'package:meno_fe_v1/src/services/media_service.dart';

class CreateBroadcastPage extends StatelessWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BroadcastFormCubit(
        facade: di<IBroadcastFacade>(),
        mediaService: di<MediaService>(),
      ),
      child: const CreateBroadcastView(),
    );
  }
}

class CreateBroadcastView extends HookWidget {
  const CreateBroadcastView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final broadcastBloc = context.read<BroadcastBloc>();
    final liveKit = context.read<LiveKitBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<BroadcastFormCubit, BroadcastFormState>(
          listenWhen: (previous, current) => previous.option != current.option,
          listener: (context, state) {
            state.option.fold(
              () {},
              (either) => either.fold(
                (error) {
                  context.read<LiveBloc>().add(const GoFailure());
                  context.showBroadcastError(error);
                },
                (b) => broadcastBloc.add(BroadcastStartPressed(b)),
              ),
            );
          },
        ),
        BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            state.status.whenOrNull(
              failure: (error) {
                context.read<LiveBloc>().add(const GoFailure());
                context.showBroadcastError(error);
              },
              broadcastStarted: () {
                liveKit.add(LiveKitBroadcast(state.broadcast.broadcastToken!));
                router.go(Routes.broadcast);
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
