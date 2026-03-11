import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/env/env.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/chat/chat.dart';

String kLiveScope(String broadcastId) => 'live-session-$broadcastId';

String? _currentScope;

Future<void> pushLiveSessionScope(BroadcastSession session) async {
  final targetScope = kLiveScope(session.broadcast.id.getOrCrash());

  // Check for already existing live scope (idempotent)
  if (di.hasScope(targetScope)) return;

  if (_currentScope != null) await popLiveSessionScope();

  // Push the live-session scope
  di.pushNewScope(scopeName: targetScope);

  // Register the broadcast session
  di.registerSingletonAsync<BroadcastSession>(() async => session);

  // LiveKit SDK Client
  di.registerSingletonAsync(() async {
    final client = LiveKitClient(url: Env.menoLiveKitUrl);
    client.initialize();
    return client;
  });

  // Chats
  di.registerSingletonWithDependencies(() {
    return ChatHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    return ChatSocketService(di<SocketClient>());
  }, dependsOn: [SocketClient]);
  di.registerSingletonWithDependencies(() {
    return ChatListManager(
      http: di<ChatHttpService>(),
      socket: di<ChatSocketService>(),
      session: session,
    );
  }, dependsOn: [ChatHttpService, ChatSocketService]);
  di.registerSingletonWithDependencies(() {
    return ChatManager(socket: di<ChatSocketService>(), session: session);
  }, dependsOn: [ChatSocketService]);

  // Participants
  di.registerSingletonWithDependencies(() {
    return ParticipantsManager(
      http: di<BroadcastHttpService>(),
      socket: di<BroadcastSocketService>(),
      session: session,
    );
  }, dependsOn: [BroadcastHttpService, BroadcastSocketService]);

  // Live Session Manager
  di.registerSingletonAsync(
    () async {
      return LiveSessionManager(
        session: session,
        local: di<BroadcastLocalService>(),
        socket: di<BroadcastSocketService>(),
        livekit: di<LiveKitClient>(),
      );
    },
    dependsOn: [BroadcastLocalService, BroadcastSocketService, LiveKitClient],
    onCreated: (manager) => manager.setupConfigs.run(),
    signalsReady: true,
  );
}

Future<void> popLiveSessionScope() async {
  if (_currentScope == null) return;

  await di.popScope();
  _currentScope = null;
}
