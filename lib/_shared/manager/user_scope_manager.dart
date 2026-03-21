import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/manager/live_scope_manager.dart';
import 'package:meno/_shared/services/_services.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno/features/discover/services/discover_local_service.dart';
import 'package:meno/features/notes/notes.dart';
import 'package:meno/features/notifications/managers/_managers.dart';
import 'package:meno/features/notifications/services/_services.dart';
import 'package:meno/features/profile/profile.dart';
import 'package:meno/features/settings/settings.dart';
import 'package:meno/global_locator.dart';

class UserScopeManager with MLogger implements Disposable {
  UserScopeManager(this._auth);

  final AuthManager _auth;

  static const String _scopeName = 'user_scope';

  Id? _currentUserId;
  ListenableSubscription? _subscription;

  Future<void> initialize() async {
    _subscription = _auth.activeUserId.listen((userId, _) async {
      if (!userId.isValid) return clearUserScope();
      if (_currentUserId != userId) return pushScope(userId);
    });

    await pushScope(_auth.activeUserId.value);
  }

  Future<void> pushScope(Id userId) async {
    log.w('UserScopeManager: Pushing started...');

    // Dispose existing scope if any
    await _disposeCurrentScope();

    // Store new user ID
    _currentUserId = userId;

    // Create fresh scope
    await di.pushNewScopeAsync(
      scopeName: _scopeName,
      init: (getIt) async => _registerDependencies(getIt, userId),
    );

    log.w('UserScopeManager: All dependencies registered');
  }

  /// Clear the user scope (on logout).
  Future<void> clearUserScope() async {
    log.w('UserScopeManager: Clearing scope');
    await _disposeCurrentScope();
    _currentUserId = null;
    log.w('UserScopeManager: Scope cleared');
  }

  // #########################################################################
  // PRIVATE METHODS
  // #########################################################################

  /// Register all user-dependent dependencies in the current scope.
  Future<void> _registerDependencies(GetIt getIt, Id currentUserId) async {
    final credential = _auth.accounts.value[currentUserId];
    if (credential == null) {
      log.w('UserScopeManager: No credentials found. Aborting.');
      return;
    }

    // User Credentials
    getIt.registerSingleton<UserCredential>(credential);

    // Web Socket Client
    getIt.registerSingletonAsync<SocketClient>(() async {
      final accessToken = credential.session.accessToken.getOrCrash();
      return SocketClient(url: Env.webSocketUrl, token: accessToken);
    }, onCreated: (client) => client.connect());

    // Notifications
    getIt.registerSingletonWithDependencies(() {
      return NotificationsHttpService(getIt<HttpClient>());
    }, dependsOn: [HttpClient]);
    getIt.registerSingletonWithDependencies(() {
      return NotificationsSocketService(getIt<SocketClient>());
    }, dependsOn: [SocketClient]);
    getIt.registerSingletonAsync(() async {
      final manager = NotificationsManager(getIt<NotificationsSocketService>());
      await manager.init();
      return manager;
    }, dependsOn: [NotificationsSocketService]);

    // Broadcasts
    getIt.registerSingletonWithDependencies(() {
      return BroadcastHttpService(getIt<HttpClient>());
    }, dependsOn: [HttpClient]);
    getIt.registerSingletonWithDependencies(() {
      return BroadcastSocketService(getIt<SocketClient>());
    }, dependsOn: [SocketClient]);
    getIt.registerSingletonWithDependencies(() {
      return BroadcastEditorManager(
        currentUserId: currentUserId,
        http: getIt<BroadcastHttpService>(),
        local: getIt<BroadcastLocalService>(),
        media: getIt<MediaService>(),
      );
    }, dependsOn: [BroadcastHttpService, BroadcastLocalService, MediaService]);
    getIt.registerSingletonWithDependencies(() {
      return StreamManager(
        currentUserId: currentUserId,
        http: getIt<BroadcastHttpService>(),
        local: getIt<BroadcastLocalService>(),
      );
    }, dependsOn: [BroadcastHttpService, BroadcastLocalService]);
    getIt.registerSingletonWithDependencies(() {
      final manager = FavouritesManager(
        currentUserId: currentUserId,
        local: getIt<BroadcastLocalService>(),
      );
      manager.fetch.run();
      return manager;
    }, dependsOn: [BroadcastLocalService]);

    // Discover
    getIt.registerSingletonWithDependencies(() {
      return DiscoverLocalService(getIt<LocalStorage>());
    }, dependsOn: [LocalStorage]);

    // Notes & Folders
    getIt.registerSingletonWithDependencies(() {
      return NotesLocalService(getIt<Database>());
    }, dependsOn: [Database]);
    getIt.registerSingletonWithDependencies(() {
      return NotesHttpService(getIt<HttpClient>());
    }, dependsOn: [HttpClient]);
    getIt.registerSingletonWithDependencies(() {
      return NotesSyncService(
        currentUserId: currentUserId,
        http: getIt<NotesHttpService>(),
        local: getIt<NotesLocalService>(),
      );
    }, dependsOn: [NotesHttpService, NotesLocalService]);
    getIt.registerSingletonWithDependencies(() {
      final manager = FoldersManager(
        currentUserId: currentUserId,
        http: getIt<NotesHttpService>(),
        local: getIt<NotesLocalService>(),
      );
      manager.initialize.run();
      return manager;
    }, dependsOn: [NotesHttpService, NotesLocalService]);
    getIt.registerSingletonWithDependencies(() {
      return NoteActionsManager(
        currentUserId: currentUserId,
        http: getIt<NotesHttpService>(),
        local: getIt<NotesLocalService>(),
      );
    }, dependsOn: [NotesHttpService, NotesLocalService]);
    getIt.registerSingletonWithDependencies(() {
      final manager = NotesManager(
        currentUserId: currentUserId,
        http: getIt<NotesHttpService>(),
        local: getIt<NotesLocalService>(),
      );
      manager.initialize.run();
      return manager;
    }, dependsOn: [NotesHttpService, NotesLocalService]);

    // Profile
    getIt.registerSingletonWithDependencies(() {
      return ProfileLocalService(getIt<LocalStorage>());
    }, dependsOn: [LocalStorage]);
    getIt.registerSingletonWithDependencies(() {
      return ProfileHttpService(getIt<HttpClient>());
    }, dependsOn: [HttpClient]);
    getIt.registerSingletonWithDependencies(() {
      final manager = MyProfileManager(
        currentUserId: currentUserId,
        http: getIt<ProfileHttpService>(),
        local: getIt<ProfileLocalService>(),
      );
      manager.fetch.run();
      return manager;
    }, dependsOn: [ProfileHttpService, ProfileLocalService]);

    // Settings Manager to  initialize from credential.
    getIt<SettingsManager>().initializeFromCredential.run(credential);

    // Live Scope Manager
    getIt.registerSingletonAsync(
      () async {
        final scope = LiveScopeManager(
          currentUserId: currentUserId,
          local: getIt<BroadcastLocalService>(),
          http: getIt<BroadcastHttpService>(),
          socket: getIt<BroadcastSocketService>(),
        );
        await scope.initialize();
        return scope;
      },
      dependsOn: [
        BroadcastLocalService,
        BroadcastHttpService,
        BroadcastSocketService,
      ],
    );
  }

  /// Dispose the current scope if it exists.
  Future<void> _disposeCurrentScope() async {
    if (_currentUserId != null && di.currentScopeName == _scopeName) {
      await di.popScopesTill(kRootScope, inclusive: false);
      log.w('UserScopeManager: Previous scope disposed');
    }
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.e('UserScopeManager: Disposing scope resources');
    _subscription?.cancel();
  }
}
