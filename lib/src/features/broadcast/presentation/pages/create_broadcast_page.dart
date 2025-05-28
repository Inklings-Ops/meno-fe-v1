import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/application/application.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class CreateBroadcastPage extends StatelessWidget {
  const CreateBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BroadcastFormCubit(mediaService: di<MediaService>()),
      child: const CreateBroadcastView(),
    );
  }
}

class CreateBroadcastView extends HookWidget {
  const CreateBroadcastView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    return BlocListener<BroadcastBloc, BroadcastState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (ctx, state) {
        switch (state.status) {
          case LiveBroadcastStatus.failure:
            final exception = state.exception;
            if (exception == null) return;
            ctx.showErrorSnackBar(exception.message);
          case LiveBroadcastStatus.started:
            final id = state.broadcast.id;
            ctx.read<ParticipantsBloc>().add(ParticipantsFetchRequested(id));
            ctx.read<ChatListBloc>().add(ChatGetMessagesRequested(id));
            ctx.read<TimerCubit>().start();
            router.replace<void>(Routes.broadcastTab);
          case LiveBroadcastStatus.initial:
          case LiveBroadcastStatus.loading:
          case LiveBroadcastStatus.joined:
          case LiveBroadcastStatus.ended:
          case LiveBroadcastStatus.left:
          case LiveBroadcastStatus.reconnecting:
          case LiveBroadcastStatus.offAir:
            return;
        }
      },
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
          persistentFooterButtons: const [StartBroadcastButton()],
        ),
      ),
    );
  }
}
