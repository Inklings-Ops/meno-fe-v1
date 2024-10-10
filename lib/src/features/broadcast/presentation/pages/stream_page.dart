import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';


class StreamPage extends HookWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MenoBloc, MenoState>(
          listener: (context, state) {
            state.whenOrNull(
              endedBroadcast: (_) {
                router.go(Routes.home);
                context.read<StreamBloc>().dispose();
              },
            );
          },
        ),
        BlocListener<StreamBloc, StreamState>(
          listener: (context, state) {
            state.whenOrNull(
              loading: () => null,
              failure: (exception) => context.showBroadcastError(exception),
              joinFailed: (e) => context.showErrorSnackBar(e.toString()),
              leaveSuccess: () {
                router.go(Routes.home);
                context.read<StreamBloc>().dispose();
              },
            );
          },
        ),
      ],
      child: BlocBuilder<StreamBloc, StreamState>(
        builder: (context, state) => state.maybeWhen(
          orElse: () => const SizedBox(),
          loading: () => const Scaffold(body: MLoadingIndicator.box()),
          joinFailed: (e) => Scaffold(body: Center(child: MText(e.toString()))),
          failure: (exception) => Scaffold(
            body: Center(
              child: MText(
                exception.maybeWhen(
                  message: (message) => message,
                  orElse: () => 'An unknown error occurred',
                  serverError: () => 'A server error occurred',
                  timeOutError: () => 'Request timed out. Go back & try again',
                ),
              ),
            ),
          ),
          joinSuccess: (_) => const LiveStreamScaffold(
            tabs: [
              Tab(text: 'Broadcast'),
              Tab(text: 'Chats'),
              Tab(text: 'Live Bible'),
              Tab(text: 'Notes'),
            ],
            tabViews: [
              StreamTab(),
              StreamChatTab(),
              LiveBibleTab(),
              NotesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
