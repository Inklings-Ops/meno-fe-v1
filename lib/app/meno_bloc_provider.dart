import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class MenoBlocProvider extends StatelessWidget {
  const MenoBlocProvider({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di<SessionCubit>()),
        BlocProvider(
          create: (_) => OnboardingCubit(facade: di<ISettingsFacade>()),
        ),
        BlocProvider(create: (_) => AccountBloc(facade: di<IAuthFacade>())),
        BlocProvider(
          create: (_) => NetworkCubit(
            facade: di<INetworkFacade>(),
          ),
        ),
        BlocProvider(
          create: (_) => MenoBloc(
            liveKit: di<LiveKitService>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (_) => RecentlyLiveCubit(
            facade: di<IBroadcastFacade>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (_) => NoteFormCubit(
            facade: di<INoteFacade>(),
            initialNote: Note.empty(),
          ),
        ),
        BlocProvider(
          create: (_) => NotesBloc(
            facade: di<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (_) => FolderCubit(
            facade: di<INoteFacade>(),
            folder: Folder.empty(),
          ),
        ),
        BlocProvider(
          create: (_) => FolderFormCubit(
            facade: di<INoteFacade>(),
          ),
        ),
        BlocProvider(
          create: (_) => FolderListBloc(
            facade: di<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (_) => BroadcastBloc(
            facade: di<IBroadcastFacade>(),
            liveKit: di<LiveKitService>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (_) => StreamBloc(
            facade: di<IBroadcastFacade>(),
            liveKit: di<LiveKitService>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            session: di<ISessionContext>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (_) => ParticipantsBloc(
            facade: di<IBroadcastFacade>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(create: (_) => TimerCubit()),
      ],
      child: child,
    );
  }
}
