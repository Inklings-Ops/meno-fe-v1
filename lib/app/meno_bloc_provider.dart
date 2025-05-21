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
        BlocProvider(create: (_) => di<SessionBloc>()),
        BlocProvider(
          lazy: false,
          create: (_) => MyProfileCubit(
            facade: di<IProfileFacade>(),
            session: di<ISessionContext>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (_) => AccountBloc(session: di<ISessionContext>()),
        ),
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(
          create: (_) => LiveKitBloc(
            liveKit: di<LiveKitService>(),
            network: di<NetworkService>(),
          ),
        ),
        BlocProvider(create: (_) => LiveBloc(liveKit: di<LiveKitService>())),
        BlocProvider(create: (_) => NetworkCubit(facade: di<INetworkFacade>())),
        BlocProvider(
          lazy: false,
          create: (_) => NotesBloc(
            facade: di<INoteFacade>(),
          )..add(const GetNotesRequested()),
        ),
        BlocProvider(
          create: (_) => NotesWatcherBloc(facade: di<INoteFacade>()),
        ),
        BlocProvider(create: (_) => TranslationBloc()),
        BlocProvider(
          create: (_) => TranslationsBloc(
            facade: di<IBibleFacade>(),
          )..add(const GetTranslations()),
        ),
        BlocProvider(
          create: (_) => BibleDownloaderBloc(facade: di<IBibleFacade>()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => FoldersBloc(
            facade: di<INoteFacade>(),
          )..add(const GetFoldersRequested()),
        ),
        BlocProvider(create: (_) => ChatInputCubit()),
        BlocProvider(
          create: (_) => ChatListBloc(
            facade: di<IChatFacade>(),
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
          create: (_) => NowLiveBloc(
            facade: di<IBroadcastFacade>(),
            socket: di<SocketService>(),
            session: di<ISessionContext>(),
          ),
        ),
        BlocProvider(
          create: (_) => RecentlyLiveBloc(
            facade: di<IBroadcastFacade>(),
            socket: di<SocketService>(),
            session: di<ISessionContext>(),
          ),
        ),
        BlocProvider(
          create: (_) => ProfileFormCubit(
            authFacade: di<IAuthFacade>(),
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
