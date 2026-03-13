import 'package:flutter_it/flutter_it.dart';
import 'package:logger/logger.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_di/global_locator.dart';
import 'package:meno/_di/live_scope_locator.dart';
import 'package:meno/_shared/services/_services.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/discover.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/settings/manager/_manager.dart';
import 'package:meno/features/settings/services/_services.dart';

const String kUserScope = 'user-session';

void pushUserSessionScope(UserCredential credential) {
  di<Logger>().d('PUSHING USER SCOPE');

  final currentUserId = credential.user.id;
  final accessToken = credential.session.accessToken.getOrCrash();

  // Push the user-session scope
  di.pushNewScope(scopeName: kUserScope);

  // User Credentials
  di.registerSingleton<UserCredential>(credential);

  // Web Socket Client
  di.registerSingletonAsync<SocketClient>(() async {
    return SocketClient(url: Env.webSocketUrl, token: accessToken);
  }, onCreated: (client) => client.connect());

  // Broadcasts
  di.registerSingletonWithDependencies(() {
    return BroadcastHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    return BroadcastSocketService(di<SocketClient>());
  }, dependsOn: [SocketClient]);
  di.registerSingletonWithDependencies(() {
    return BroadcastEditorManager(
      currentUserId: currentUserId,
      http: di<BroadcastHttpService>(),
      local: di<BroadcastLocalService>(),
      media: di<MediaService>(),
    );
  }, dependsOn: [BroadcastHttpService, BroadcastLocalService, MediaService]);
  di.registerSingletonWithDependencies(() {
    return StreamManager(
      currentUserId: currentUserId,
      http: di<BroadcastHttpService>(),
      local: di<BroadcastLocalService>(),
    );
  }, dependsOn: [BroadcastHttpService, BroadcastLocalService]);
  di.registerSingletonWithDependencies(() {
    return FavouritesManager(
      currentUserId: currentUserId,
      local: di<BroadcastLocalService>(),
    );
  }, dependsOn: [BroadcastLocalService]);

  // Discover
  di.registerSingletonWithDependencies(() {
    return DiscoverLocalService(di<LocalStorage>());
  }, dependsOn: [LocalStorage]);

  // Notes & Folders
  di.registerSingletonWithDependencies(() {
    return NotesLocalService(di<Database>());
  }, dependsOn: [Database]);
  di.registerSingletonWithDependencies(() {
    return NotesHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    final manager = FoldersManager(
      http: di<NotesHttpService>(),
      local: di<NotesLocalService>(),
    );
    manager.initialize.run();
    return manager;
  }, dependsOn: [NotesHttpService, NotesLocalService]);
  di.registerSingletonWithDependencies(() {
    return NoteActionsManager(
      http: di<NotesHttpService>(),
      local: di<NotesLocalService>(),
    );
  }, dependsOn: [NotesHttpService, NotesLocalService]);
  di.registerSingletonWithDependencies(() {
    final manager = NotesManager(
      http: di<NotesHttpService>(),
      local: di<NotesLocalService>(),
    );
    manager.initialize.run();
    return manager;
  }, dependsOn: [NotesHttpService, NotesLocalService]);

  // Profile
  di.registerSingletonWithDependencies(() {
    return ProfileLocalService(di<LocalStorage>());
  }, dependsOn: [LocalStorage]);
  di.registerSingletonWithDependencies(() {
    return ProfileHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    final manager = MyProfileManager(
      currentUserId: currentUserId,
      http: di<ProfileHttpService>(),
      local: di<ProfileLocalService>(),
    );
    manager.fetch.run();
    return manager;
  }, dependsOn: [ProfileHttpService, ProfileLocalService]);

  // Settings
  di.registerSingletonWithDependencies(() {
    return SettingsHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  di.registerSingletonWithDependencies(() {
    return SettingsManager(
      currentUserId: currentUserId,
      http: di<SettingsHttpService>(),
      local: di<SettingsLocalService>(),
    );
  }, dependsOn: [SettingsHttpService, SettingsLocalService]);

  // "Zombie" Session
  final localBroadcast = di<BroadcastLocalService>();
  final zombieSession = localBroadcast.getActiveBroadcastSession(currentUserId);
  if (zombieSession != null) pushLiveSessionScope(zombieSession);

  di<Logger>().f('FINISHED PUSHING USER SCOPE');
}

Future<void> popUserSessionScope() async {
  if (di.currentScopeName == kUserScope || di.hasScope(kUserScope)) {
    await di.popScopesTill(kRootScope);
  }
}
