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
    required Id? currentUserId,
  }) : _http = http,
       _local = local,
       _currentUserId = currentUserId {
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
        await _http.updateUserSettings(UserSettingsPatch(language: input));
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(language: oldInput);
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleDarkMode = Command.createUndoableNoResult<bool, UserDisplay>(
      (input, stack) async {
        stack.push(settings.value.display);
        final display = input ? UserDisplay.dark : UserDisplay.light;
        settings.value = settings.value.copyWith(display: display);
        _persistLocally();
        await _http.updateUserSettings(UserSettingsPatch(display: display));
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(display: oldInput);
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleAppNotifications = Command.createUndoableNoResult<bool, bool>(
      (input, stack) async {
        stack.push(settings.value.appNotifications);
        settings.value = settings.value.copyWith(appNotifications: input);
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(appNotifications: input),
        );
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(appNotifications: oldInput);
      },
      errorFilterFn: menoExceptionFilter,
    );
    togglePushNotifications = Command.createUndoableNoResult<bool, bool>(
      (input, stack) async {
        stack.push(settings.value.pushNotifications);
        settings.value = settings.value.copyWith(pushNotifications: input);
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(pushNotifications: input),
        );
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(pushNotifications: oldInput);
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleEmailNotifications = Command.createUndoableNoResult<bool, bool>(
      (input, stack) async {
        stack.push(settings.value.emailNotifications);
        settings.value = settings.value.copyWith(emailNotifications: input);
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(emailNotifications: input),
        );
      },
      undo: (stack, reason) {
        final oldInput = stack.pop();
        settings.value = settings.value.copyWith(emailNotifications: oldInput);
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleLiveBroadcastNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.liveBroadcastStarted);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            liveBroadcastStarted: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(
            notificationSettings: UserNotificationSettingsPatch(
              liveBroadcastStarted: input,
            ),
          ),
        );
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            liveBroadcastStarted: oldInput,
          ),
        );
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleSubscribersNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.userSubscribed);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            userSubscribed: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(
            notificationSettings: UserNotificationSettingsPatch(
              userSubscribed: input,
            ),
          ),
        );
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            userSubscribed: oldInput,
          ),
        );
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleAddedAsCohostNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.addedAsCoHost);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            addedAsCoHost: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(
            notificationSettings: UserNotificationSettingsPatch(
              addedAsCoHost: input,
            ),
          ),
        );
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            addedAsCoHost: oldInput,
          ),
        );
      },
      errorFilterFn: menoExceptionFilter,
    );
    toggleScheduledBroadcastNotifications = Command.createUndoableNoResult(
      (input, stack) async {
        final current = settings.value;
        stack.push(current.notificationSettings.scheduledBroadcast);
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            scheduledBroadcast: input,
          ),
        );
        _persistLocally();
        await _http.updateUserSettings(
          UserSettingsPatch(
            notificationSettings: UserNotificationSettingsPatch(
              scheduledBroadcast: input,
            ),
          ),
        );
      },
      undo: (UndoStack<bool> stack, reason) {
        final oldInput = stack.pop();
        final current = settings.value;
        settings.value = current.copyWith(
          notificationSettings: current.notificationSettings.copyWith(
            scheduledBroadcast: oldInput,
          ),
        );
      },
      errorFilterFn: menoExceptionFilter,
    );
  }

  final SettingsHttpService _http;
  final SettingsLocalService _local;

  /// Null when the user is a guest. All persistence calls are no-ops in that
  /// case — settings live in memory only and reset on next cold start.
  final Id? _currentUserId;

  bool get _isGuest => _currentUserId == null;

  final settings = ValueNotifier<UserSettings>(const UserSettings());

  Future<SettingsManager> initialize() async {
    await _loadFromCache();
    if (!_isGuest) syncFromRemote.run();
    return this;
  }

  late final Command<UserCredential, void> initializeFromCredential;
  late final Command<void, void> syncFromRemote;
  late final Command<void, void> syncToRemote;
  late final Command<String, void> changeLanguage;
  late final Command<bool, void> toggleDarkMode;
  late final Command<bool, void> toggleAppNotifications;
  late final Command<bool, void> togglePushNotifications;
  late final Command<bool, void> toggleEmailNotifications;
  late final Command<bool, void> toggleLiveBroadcastNotifications;
  late final Command<bool, void> toggleSubscribersNotifications;
  late final Command<bool, void> toggleAddedAsCohostNotifications;
  late final Command<bool, void> toggleScheduledBroadcastNotifications;

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

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
  FutureOr<dynamic> onDispose() {
    log.d('NotesManager: Disposing...');

    settings.dispose();

    initializeFromCredential.dispose();
    syncFromRemote.dispose();
    syncToRemote.dispose();
    changeLanguage.dispose();
    toggleDarkMode.dispose();
    toggleAppNotifications.dispose();
    togglePushNotifications.dispose();
    toggleEmailNotifications.dispose();
    toggleLiveBroadcastNotifications.dispose();
    toggleSubscribersNotifications.dispose();
    toggleAddedAsCohostNotifications.dispose();
    toggleScheduledBroadcastNotifications.dispose();
  }
}
