import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/services.dart';
import 'package:meno/features/auth/auth.dart';

const String kUserScopeName = 'user-session';

void pushUserSessionScope(UserCredential credential) {
  di.registerSingleton<UserCredential>(credential);
  di.registerSingletonAsync<SocketClient>(() async {
    return SocketClient(
      url: Env.webSocketUrl,
      token: credential.session.accessToken.getOrCrash(),
    );
  }, onCreated: (client) => client.connect());
}

Future<void> popUserSessionScope() async {
  if (di.currentScopeName == kUserScopeName) {
    await di.popScope();
  }
}
