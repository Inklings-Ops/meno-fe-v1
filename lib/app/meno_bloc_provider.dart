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
        BlocProvider(create: (_) => SocketBloc()),
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(create: (_) => LiveKitBloc(liveKit: di<LiveKitService>())),
        BlocProvider(create: (_) => LiveBloc(liveKit: di<LiveKitService>())),
        BlocProvider(create: (_) => AccountBloc(facade: di<IAuthFacade>())),
        BlocProvider(create: (_) => NetworkCubit(facade: di<INetworkFacade>())),
        BlocProvider(create: (_) => ChatBloc(facade: di<IChatFacade>())),
        BlocProvider(create: (_) => StreamBloc(facade: di<IBroadcastFacade>())),
        BlocProvider(
          create: (_) => BroadcastBloc(facade: di<IBroadcastFacade>()),
        ),
        BlocProvider(
          create: (_) => ParticipantsBloc(facade: di<IBroadcastFacade>()),
        ),
        BlocProvider(
          create: (_) => OnboardingCubit(facade: di<ISettingsFacade>()),
        ),
        // TODO(gettoknowdavid): move folder bloc
        BlocProvider(create: (_) => FolderFormCubit(facade: di<INoteFacade>())),
        BlocProvider(create: (_) => FolderListBloc(facade: di<INoteFacade>())),
        BlocProvider(
          create: (_) => FolderCubit(
            facade: di<INoteFacade>(),
            folder: Folder.empty(),
          ),
        ),

        // TODO(gettoknowdavid): move notes bloc
        BlocProvider(create: (_) => NotesBloc(facade: di<INoteFacade>())),

        // TODO(gettoknowdavid): move Bible blocs

        BlocProvider(
          create: (_) => RecentlyLiveCubit(
            facade: di<IBroadcastFacade>(),
          )..fetch(),
        ),
      ],
      child: child,
    );
  }
}
