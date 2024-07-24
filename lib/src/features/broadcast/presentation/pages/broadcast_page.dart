

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class BroadcastPage extends HookWidget {
  const BroadcastPage({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<BroadcastBloc>();
    useEffect(() {
      bloc.add(BroadcastStartRequested(broadcast.id));
      return null;
    }, const []);
    return BlocConsumer<BroadcastBloc, BroadcastState>(
      bloc: bloc,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        bloc.state.whenOrNull(
          failure: (exception) => context.showBroadcastError(exception),
          startFailed: (e) => context.showErrorSnackBar(e.toString()),
          deleteSuccess: () => context.go(Routes.home),
          endSuccess: () {
            context.read<TimerCubit>().stop();
            di<LiveKitService>().dispose();
            context.showModal(
              const BroadcastEndedModal(),
              enableDrag: false,
              useRootNavigator: true,
              isDismissible: false,
              isScrollControlled: true,
            );
          },
          startSuccess: (broadcast, muted) {
            context.read<TimerCubit>().start();
            context.read<LiveParticipantsBloc>().initialize(broadcast);
            context.read<ChatBloc>().initialize(broadcast);
          },
        );
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        startFailed: (e) => Scaffold(body: Center(child: MText(e.toString()))),
        loading: () => const Scaffold(body: MLoadingIndicator.box()),
        failure: (exception) => Scaffold(
          body: Center(
            child: MText(exception.maybeWhen(
              message: (message) => message,
              orElse: () => 'An unknown error occurred',
              serverError: () => 'A server error occurred',
              timeOutError: () => 'Request timed out. Go back & try again',
            )),
          ),
        ),
        startSuccess: (broadcast, muted) => const PopScope(
          canPop: false,
          child: LiveStreamScaffold(
            tabs: [
              Tab(text: 'Broadcast'),
              Tab(text: 'Chats'),
              Tab(text: 'Live Bible'),
              Tab(text: 'Notes'),
            ],
            tabViews: [
              BroadcastTab(),
              BroadcastChatTab(),
              LiveBibleTab(),
              NotesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
