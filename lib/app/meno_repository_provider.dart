import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

class MenoRepositoryProvider extends StatelessWidget {
  const MenoRepositoryProvider({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => di<IAuthFacade>()),
        RepositoryProvider(create: (context) => di<ISessionContext>()),
        RepositoryProvider(create: (context) => di<IBroadcastFacade>()),
        RepositoryProvider(create: (context) => di<ISettingsFacade>()),
        RepositoryProvider(create: (context) => di<INoteFacade>()),
        RepositoryProvider(create: (context) => di<INetworkFacade>()),
        RepositoryProvider(create: (context) => di<IProfileFacade>()),
        RepositoryProvider(create: (context) => di<IDiscoverFacade>()),
        RepositoryProvider(create: (context) => di<IBibleFacade>()),
        RepositoryProvider(create: (context) => di<LiveKitService>()),
        RepositoryProvider(create: (context) => di<SocketService>()),
        RepositoryProvider(create: (context) => di<MediaService>()),
      ],
      child: child,
    );
  }
}
