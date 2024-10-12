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
        BlocProvider(create: (ctx) => di<SessionCubit>()),
        BlocProvider(
          create: (ctx) => NetworkCubit(facade: ctx.read<INetworkFacade>()),
        ),
        BlocProvider(
          create: (ctx) => OnboardingCubit(facade: ctx.read<ISettingsFacade>()),
        ),
        BlocProvider(create: (ctx) => TimerCubit()),
        BlocProvider(
          create: (ctx) => BibleBloc(facade: ctx.read<IBibleFacade>())..init(),
        ),
        BlocProvider(
          create: (ctx) => ScripturePickerCubit(
            facade: ctx.read<IBibleFacade>(),
          ),
        ),
        BlocProvider(
          create: (ctx) => TranslationsCubit(
            facade: ctx.read<IBibleFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => VersesCubit(facade: ctx.read<IBibleFacade>()),
        ),
        BlocProvider(
          create: (ctx) => AccountBloc(facade: ctx.read<IAuthFacade>())..init(),
        ),
        BlocProvider(
          create: (ctx) => LoginCubit(
            facade: ctx.read<IAuthFacade>(),
            settingsFacade: ctx.read<ISettingsFacade>(),
          ),
        ),
        BlocProvider(
          create: (ctx) => RegisterCubit(facade: ctx.read<IAuthFacade>()),
        ),
        BlocProvider(
          create: (ctx) => MyProfileBloc(facade: ctx.read<IProfileFacade>()),
        ),
        BlocProvider(
          create: (ctx) => ProfileFormCubit(
            facade: ctx.read<IProfileFacade>(),
            media: ctx.read<MediaService>(),
          ),
        ),
        BlocProvider(
          create: (ctx) => MenoBloc(
            liveKit: ctx.read<LiveKitService>(),
            socket: ctx.read<SocketService>(),
          ),
        ),
        BlocProvider(
          create: (ctx) => LiveBroadcastsBloc(
            facade: ctx.read<IBroadcastFacade>(),
            socket: ctx.read<SocketService>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => NoteFormCubit(facade: ctx.read<INoteFacade>()),
        ),
        BlocProvider(
          create: (ctx) => RecentlyLiveCubit(
            facade: ctx.read<IBroadcastFacade>(),
          )..fetch(),
        ),
        BlocProvider(
          create: (ctx) => SearchBloc(facade: ctx.read<IDiscoverFacade>()),
        ),
        BlocProvider(
          create: (ctx) => FolderCubit(
            facade: ctx.read<INoteFacade>(),
            folder: Folder.empty(),
          ),
        ),
        BlocProvider(
          create: (ctx) => DAllCubit(
            facade: ctx.read<IDiscoverFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => DNowLiveCubit(
            facade: ctx.read<IDiscoverFacade>(),
          )..fetch(1),
        ),
        BlocProvider(
          create: (ctx) => DRecentlyLiveCubit(
            facade: ctx.read<IDiscoverFacade>(),
          )..fetch(1),
        ),
        BlocProvider(
          create: (ctx) => FilterBloc(
            facade: ctx.read<IDiscoverFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => NotesBloc(
            facade: ctx.read<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => FolderFormCubit(facade: ctx.read<INoteFacade>()),
        ),
        BlocProvider(
          create: (ctx) => FolderListBloc(
            facade: ctx.read<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => FolderListBloc(
            facade: ctx.read<INoteFacade>(),
          )..init(),
        ),
        BlocProvider(
          create: (ctx) => StreamBloc(
            facade: ctx.read<IBroadcastFacade>(),
            liveKit: ctx.read<LiveKitService>(),
            socket: di<SocketService>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
