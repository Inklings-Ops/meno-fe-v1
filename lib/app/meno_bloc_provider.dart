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
        BlocProvider(create: (context) => di<SessionCubit>()),
        BlocProvider(
          create: (context) => NetworkCubit(
            facade: context.read<INetworkFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => OnboardingCubit(
            facade: context.read<ISettingsFacade>(),
          ),
        ),
        BlocProvider(create: (context) => TimerCubit()),
        BlocProvider(
          create: (context) => BibleBloc(
            facade: context.read<IBibleFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => ScripturePickerCubit(
            facade: context.read<IBibleFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => TranslationsCubit(
            facade: context.read<IBibleFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => VersesCubit(
            facade: context.read<IBibleFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => AccountBloc(
            facade: context.read<IAuthFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            facade: context.read<IAuthFacade>(),
            settingsFacade: context.read<ISettingsFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(
            facade: context.read<IAuthFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => MyProfileCubit(
            facade: context.read<IProfileFacade>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => ProfileFormCubit(
            facade: context.read<IProfileFacade>(),
            media: context.read<MediaService>(),
          ),
        ),
        BlocProvider(
          create: (context) => MenoBloc(
            liveKit: context.read<LiveKitService>(),
            socket: context.read<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (context) => LiveBroadcastsBloc(
            facade: context.read<IBroadcastFacade>(),
            socket: context.read<SocketService>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => NoteFormCubit(
            facade: context.read<INoteFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => RecentlyLiveCubit(
            facade: context.read<IBroadcastFacade>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(
            facade: context.read<IDiscoverFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => FolderCubit(
            facade: context.read<INoteFacade>(),
            folder: Folder.empty(),
          ),
        ),
        BlocProvider(
          create: (context) => DAllCubit(
            facade: context.read<IDiscoverFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => DNowLiveCubit(
            facade: context.read<IDiscoverFacade>(),
          )..fetch(1),
        ),
        BlocProvider(
          create: (context) => DRecentlyLiveCubit(
            facade: context.read<IDiscoverFacade>(),
          )..fetch(1),
        ),
        BlocProvider(
          create: (context) => FilterBloc(
            facade: context.read<IDiscoverFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => NotesBloc(
            facade: context.read<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => FolderFormCubit(
            facade: context.read<INoteFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => FolderListBloc(
            facade: context.read<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => FolderListBloc(
            facade: context.read<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (context) => BroadcastBloc(
            facade: context.read<IBroadcastFacade>(),
            liveKit: context.read<LiveKitService>(),
            socket: context.read<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (context) => StreamBloc(
            facade: context.read<IBroadcastFacade>(),
            liveKit: context.read<LiveKitService>(),
            socket: di<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (context) => OthersProfileCubit(
            facade: context.read<IProfileFacade>(),
          ),
        ),
        BlocProvider(
          create: (context) => ChatBloc(
            session: context.read<ISessionContext>(),
            socket: context.read<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (context) => ParticipantsBloc(
            facade: context.read<IBroadcastFacade>(),
            socket: context.read<SocketService>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
