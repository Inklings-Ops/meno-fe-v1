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
    required Id currentUserId,
  }) : _http = http,
       _local = local,
       _currentUserId = currentUserId;

  final SettingsHttpService _http;
  final SettingsLocalService _local;
  final Id _currentUserId;

  final settings = ValueNotifier<UserSettings>(const UserSettings());
  final error = ValueNotifier<MenoException?>(null);

  void toggleDarkMode(bool value) {
    final userDisplay = value ? UserDisplay.dark : UserDisplay.light;
    settings.value = settings.value.copyWith(display: userDisplay);
    _updateSettingsWithoutWaiting();
  }

  void toggleLocation(bool value) {
    settings.value = settings.value.copyWith();
    // _updateSettingsWithoutWaiting();
  }

  late final initialize = Command.createSyncNoResult((UserCredential cred) {
    final generalSettings = cred.user.generalSettings;
    final userSettings = UserSettings.fromGeneralSettings(generalSettings!);
    settings.value = userSettings;
    _updateSettingsWithoutWaiting();
  }, errorFilterFn: menoExceptionFilter);

  late final _syncFromRemote = Command.createAsyncNoParamNoResult(() async {
    final result = await _http.getUserSettings();
    settings.value = result.toDomain;
    await _updateSettingsWithoutWaiting();
  }, errorFilterFn: menoExceptionFilter);

  Future<void> _updateSettingsWithoutWaiting() async {
    await _local.saveUserSettings(
      _currentUserId.getOrCrash(),
      settings.value.toDto,
    );
  }

  @override
  FutureOr<dynamic> onDispose() {
    log.d('NotesManager: Disposing...');

    settings.dispose();
    error.dispose();

    initialize.dispose();
    _syncFromRemote.dispose();
  }
}
