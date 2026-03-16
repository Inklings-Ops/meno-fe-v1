import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/settings/model/_model.dart';
import 'package:meno/features/settings/services/_services.dart';

class SettingsManager with MLogger implements Disposable {
  SettingsManager({
    required SettingsHttpService http,
    required SettingsLocalService local,
    required AuthManager auth,
  }) : _http = http,
       _local = local,
       _auth = auth {
    initializeFromCredential = Command.createSyncNoResult((UserCredential arg) {
      final generalSettings = arg.user.generalSettings;
      if (generalSettings == null) return;
      final userSettings = UserSettings.fromGeneralSettings(generalSettings);
      if (settings.value == const UserSettings()) {
        settings.value = userSettings;
      }
      _persistLocally();
    }, errorFilterFn: menoExceptionFilter);
    syncFromRemote = Command.createAsyncNoParamNoResult(() async {
      if (_isGuest) return;
      final dto = await _http.getUserSettings();
      settings.value = dto.toDomain;
      _persistLocally();
    }, errorFilterFn: menoExceptionFilter);
    syncToRemote = Command.createAsyncNoParamNoResult(() async {
      if (_isGuest) return;
      await _http.syncSettings(settings.value.toDto);
    }, errorFilterFn: menoExceptionFilter);
    changeLanguage = Command.createUndoableNoResult<String, String>(
      (input, stack) async {
        stack.push(settings.value.language);
        settings.value = settings.value.copyWith(language: input);
        _persistLocally();
        await _http.updateUserSettings(language: input);
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(language: oldInput);
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleDarkMode = Command.createUndoableNoResult<bool, UserDisplay>(
      (input, stack) async {
        stack.push(settings.value.display);
        final display = input ? UserDisplay.dark : UserDisplay.light;
        settings.value = settings.value.copyWith(display: display);
        _persistLocally();
        await _http.updateUserSettings(display: display.value);
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(display: oldInput);
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setAppNotifications = Command.createUndoableNoResult<bool, bool>(
      (input, stack) async {
        stack.push(settings.value.appNotifications);
        settings.value = settings.value.copyWith(appNotifications: input);
        _persistLocally();
        await _http.updateUserSettings(appNotifications: input);
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(appNotifications: oldInput);
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setPushNotifications = Command.createUndoableNoResult<bool, bool>(
      (input, stack) async {
        stack.push(settings.value.pushNotifications);
        settings.value = settings.value.copyWith(pushNotifications: input);
        _persistLocally();
        await _http.updateUserSettings(pushNotifications: input);
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(pushNotifications: oldInput);
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setEmailNotifications = Command.createUndoableNoResult<bool, bool>(
      (input, stack) async {
        stack.push(settings.value.emailNotifications);
        settings.value = settings.value.copyWith(emailNotifications: input);
        _persistLocally();
        await _http.updateUserSettings(emailNotifications: input);
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(emailNotifications: oldInput);
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setLiveBroadcastNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.liveBroadcastStarted);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            liveBroadcastStarted: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(liveBroadcastStarted: input);
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            liveBroadcastStarted: oldInput,
          ),
        );
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setSubscribersNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.userSubscribed);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            userSubscribed: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(userSubscribed: input);
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            userSubscribed: oldInput,
          ),
        );
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setAddedAsCohostNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.addedAsCoHost);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            addedAsCoHost: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(addedAsCoHost: input);
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            addedAsCoHost: oldInput,
          ),
        );
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
    setScheduledBroadcastNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.scheduledBroadcast);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            scheduledBroadcast: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(scheduledBroadcast: input);
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            scheduledBroadcast: oldInput,
          ),
        );
        _persistLocally();
      },
      errorFilterFn: menoExceptionFilter,
    );
  }

  final SettingsHttpService _http;
  final SettingsLocalService _local;
  final AuthManager _auth;

  Id? _currentUserId;

  ListenableSubscription? _authSubscription;

  bool get _isGuest => _currentUserId == null || !_currentUserId!.isValid;

  final settings = ValueNotifier<UserSettings>(const UserSettings());

  Future<SettingsManager> initialize() async {
    _currentUserId = _auth.activeUserId.value;
    _authSubscription = _auth.activeUserId.listen((userId, _) {
      _onAuthChanged(userId);
    });
    await _loadFromCache();
    if (!_isGuest) syncFromRemote.run();
    return this;
  }

  late final Command<UserCredential, void> initializeFromCredential;
  late final Command<void, void> syncFromRemote;
  late final Command<void, void> syncToRemote;
  late final Command<String, void> changeLanguage;
  late final Command<bool, void> toggleDarkMode;
  late final Command<bool, void> setAppNotifications;
  late final Command<bool, void> setPushNotifications;
  late final Command<bool, void> setEmailNotifications;
  late final Command<bool, void> setLiveBroadcastNotifications;
  late final Command<bool, void> setSubscribersNotifications;
  late final Command<bool, void> setAddedAsCohostNotifications;
  late final Command<bool, void> setScheduledBroadcastNotifications;

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  void _onAuthChanged(Id? userId) {
    if (_currentUserId == userId) return;
    _currentUserId = userId;

    if (_isGuest) {
      settings.value = const UserSettings();
    } else {
      unawaited(_loadFromCache().then((_) => syncFromRemote.run()));
    }
  }

  /// Loads the cached [UserSettingsDto] for the current user from local
  /// storage and populates [settings]. Falls back to [UserSettings] defaults
  /// if no cache entry exists (first launch or guest).
  Future<void> _loadFromCache() async {
    if (_isGuest) return;
    final cached = _local.getUserSettings(_currentUserId!.getOrCrash());
    if (cached != null) settings.value = cached.toDomain;
  }

  /// Writes the current [settings] value to local storage.
  /// No-op for guests.
  void _persistLocally() {
    if (_isGuest) return;
    unawaited(
      _local.saveUserSettings(
        _currentUserId!.getOrCrash(),
        settings.value.toDto,
      ),
    );
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('SettingsManager: Disposing...');

    await syncToRemote.runAsync();

    _authSubscription?.cancel();
    settings.dispose();

    initializeFromCredential.dispose();
    syncFromRemote.dispose();
    syncToRemote.dispose();
    changeLanguage.dispose();
    toggleDarkMode.dispose();
    setAppNotifications.dispose();
    setPushNotifications.dispose();
    setEmailNotifications.dispose();
    setLiveBroadcastNotifications.dispose();
    setSubscribersNotifications.dispose();
    setAddedAsCohostNotifications.dispose();
    setScheduledBroadcastNotifications.dispose();
  }
}
