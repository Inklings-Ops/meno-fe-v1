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

final _log = di<Logger>();

const String kUserScope = 'user-session';

Future<void> pushUserSessionScope(UserCredential credential) async {
  // Dispose existing scope if any
  await popUserSessionScope();

  _log.f('USER_SCOPE: Switching to USER(${credential.user.id.getOrCrash()})');

  // Push the user-session scope
  await di.pushNewScopeAsync(
    scopeName: kUserScope,
    init: (getIt) => _registerDependencies(getIt, credential),
  );
}

Future<void> popUserSessionScope() async {
  if (di.hasScope(kUserScope) || di.currentScopeName == kUserScope) {
    _log.f('USER_SCOPE: Popping scope for USER');
    await di.popScopesTill(kRootScope, inclusive: false);
  }
}

Future<void> _registerDependencies(
  GetIt getIt,
  UserCredential credential,
) async {
  final currentUserId = credential.user.id;
  final accessToken = credential.session.accessToken.getOrCrash();

  _log.f('USER_SCOPE: Registering dependencies for USER($currentUserId)');

  // User Credentials
  getIt.registerSingleton<UserCredential>(credential);

  // Web Socket Client
  getIt.registerSingletonAsync<SocketClient>(() async {
    return SocketClient(url: Env.webSocketUrl, token: accessToken);
  }, onCreated: (client) => client.connect());

  // Broadcasts
  getIt.registerSingletonWithDependencies(() {
    return BroadcastHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  getIt.registerSingletonWithDependencies(() {
    return BroadcastSocketService(di<SocketClient>());
  }, dependsOn: [SocketClient]);
  getIt.registerSingletonWithDependencies(() {
    return BroadcastEditorManager(
      currentUserId: currentUserId,
      http: di<BroadcastHttpService>(),
      local: di<BroadcastLocalService>(),
      media: di<MediaService>(),
    );
  }, dependsOn: [BroadcastHttpService, BroadcastLocalService, MediaService]);
  getIt.registerSingletonWithDependencies(() {
    return StreamManager(
      currentUserId: currentUserId,
      http: di<BroadcastHttpService>(),
      local: di<BroadcastLocalService>(),
    );
  }, dependsOn: [BroadcastHttpService, BroadcastLocalService]);
  getIt.registerSingletonWithDependencies(() {
    final manager = FavouritesManager(
      currentUserId: currentUserId,
      local: di<BroadcastLocalService>(),
    );
    manager.fetch.run();
    return manager;
  }, dependsOn: [BroadcastLocalService]);

  // Discover
  getIt.registerSingletonWithDependencies(() {
    return DiscoverLocalService(di<LocalStorage>());
  }, dependsOn: [LocalStorage]);

  // Notes & Folders
  getIt.registerSingletonWithDependencies(() {
    return NotesLocalService(di<Database>());
  }, dependsOn: [Database]);
  getIt.registerSingletonWithDependencies(() {
    return NotesHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  getIt.registerSingletonWithDependencies(() {
    final manager = FoldersManager(
      http: di<NotesHttpService>(),
      local: di<NotesLocalService>(),
      currentUserId: currentUserId,
    );
    manager.initialize.run();
    return manager;
  }, dependsOn: [NotesHttpService, NotesLocalService]);
  getIt.registerSingletonWithDependencies(() {
    return NoteActionsManager(
      http: di<NotesHttpService>(),
      local: di<NotesLocalService>(),
      currentUserId: currentUserId,
    );
  }, dependsOn: [NotesHttpService, NotesLocalService]);
  getIt.registerSingletonWithDependencies(() {
    final manager = NotesManager(
      http: di<NotesHttpService>(),
      local: di<NotesLocalService>(),
      currentUserId: currentUserId,
    );
    manager.initialize.run();
    return manager;
  }, dependsOn: [NotesHttpService, NotesLocalService]);

  // Profile
  getIt.registerSingletonWithDependencies(() {
    return ProfileLocalService(di<LocalStorage>());
  }, dependsOn: [LocalStorage]);
  getIt.registerSingletonWithDependencies(() {
    return ProfileHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  getIt.registerSingletonWithDependencies(() {
    final manager = MyProfileManager(
      currentUserId: currentUserId,
      http: di<ProfileHttpService>(),
      local: di<ProfileLocalService>(),
    );
    manager.fetch.run();
    return manager;
  }, dependsOn: [ProfileHttpService, ProfileLocalService]);

  // Settings
  getIt.registerSingletonWithDependencies(() {
    return SettingsHttpService(di<HttpClient>());
  }, dependsOn: [HttpClient]);
  getIt.registerSingletonWithDependencies(() {
    return SettingsManager(
      currentUserId: currentUserId,
      http: di<SettingsHttpService>(),
      local: di<SettingsLocalService>(),
    );
  }, dependsOn: [SettingsHttpService, SettingsLocalService]);

  // "Zombie" Session
  final localBroadcast = di<BroadcastLocalService>();
  final zombieSession = localBroadcast.getActiveBroadcastSession(currentUserId);
  if (zombieSession != null) await pushLiveSessionScope(zombieSession);

  _log.f('USER_SCOPE: All dependencies registered for USER($currentUserId)');
}
