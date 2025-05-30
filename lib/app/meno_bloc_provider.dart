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
        BlocProvider(create: (_) => SocketBloc(socket: di<SocketService>())),
        BlocProvider(create: (_) => SettingsBloc()),
        BlocProvider(create: (_) => di<SessionBloc>()..init()),
        BlocProvider(
          lazy: false,
          create: (_) => MyProfileCubit(
            facade: di<IProfileFacade>(),
            session: di<ISessionContext>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (_) => AccountBloc(
            session: di<ISessionContext>(),
          )..add(const AccountInitialized()),
        ),
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(create: (_) => NetworkCubit(facade: di<INetworkFacade>())),
        BlocProvider(
          lazy: false,
          create: (_) => NotesBloc(
            facade: di<INoteFacade>(),
          )..add(const NotesFetchNotesRequested()),
        ),
        BlocProvider(
          create: (_) => NotesWatcherBloc(facade: di<INoteFacade>()),
        ),
        BlocProvider(create: (_) => TranslationBloc()),
        BlocProvider(
          create: (_) => TranslationsBloc(
            facade: di<IBibleFacade>(),
          )..add(const TranslationsFetchRequested()),
        ),
        BlocProvider(
          create: (_) => BibleDownloaderBloc(facade: di<IBibleFacade>()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => FoldersBloc(
            facade: di<INoteFacade>(),
          )..add(const FoldersGetFoldersRequested()),
        ),
        BlocProvider(create: (_) => ChatInputCubit()),
        BlocProvider(
          create: (_) => ChatListBloc(
            session: di<ISessionContext>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (_) => BroadcastBloc(
            endBroadcastUsecase: di<EndBroadcastUsecase>(),
            leaveBroadcastUsecase: di<LeaveBroadcastUsecase>(),
            reconnectBroadcastUsecase: di<ReconnectBroadcastUsecase>(),
            startBroadcastUsecase: di<StartBroadcastUsecase>(),
            joinBroadcastUsecase: di<JoinBroadcastUsecase>(),
            // socket: di<SocketService>(),
            liveKit: di<LiveKitService>(),
          ),
        ),
        BlocProvider(
          create: (_) => ParticipantsBloc(
            facade: di<IBroadcastFacade>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (_) => OnboardingCubit(facade: di<ISettingsFacade>()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => NowLiveBloc(
            facade: di<IBroadcastFacade>(),
            socket: di<SocketService>(),
            session: di<ISessionContext>(),
          )..add(const NowLiveStarted()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => RecentlyLiveBloc(
            facade: di<IBroadcastFacade>(),
            socket: di<SocketService>(),
            session: di<ISessionContext>(),
          )..add(const RecentlyLiveStarted()),
        ),
        BlocProvider(
          create: (_) => ProfileFormCubit(
            facade: di<IProfileFacade>(),
            media: di<MediaService>(),
          ),
        ),
        BlocProvider(
          create: (_) => SubscriptionBloc(
            facade: di<IProfileFacade>(),
            session: di<ISessionContext>(),
          )..init,
        ),
      ],
      child: child,
    );
  }
}
