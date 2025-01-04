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
        BlocProvider(create: (_) => NotesBloc(facade: di<INoteFacade>())),
        BlocProvider(
          create: (_) => NotesWatcherBloc(facade: di<INoteFacade>()),
        ),
        BlocProvider(create: (_) => FoldersBloc(facade: di<INoteFacade>())),
        BlocProvider(create: (_) => ChatBloc()),
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
        BlocProvider(
          create: (_) => RecentlyLiveCubit(
            facade: di<IBroadcastFacade>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (_) => LiveBroadcastsBloc(
            facade: di<IBroadcastFacade>(),
          )..init(),
        ),
      ],
      child: child,
    );
  }
}
