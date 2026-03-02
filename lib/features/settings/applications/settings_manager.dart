import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/settings/domain/domain.dart';
import 'package:meno/shared/shared.dart';

class SettingsManager with MLogger implements Disposable {
  SettingsManager({
    required ISettingsRepository repository,
    required Id currentUserId,
  }) : _repository = repository,
       _currentUserId = currentUserId;

  final ISettingsRepository _repository;
  final Id _currentUserId;

  late final settings = ValueNotifier<UserSettings>(const UserSettings());
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

  late final initialize = Command.createSyncNoResult((
    UserCredential credential,
  ) {
    final generalSettings = credential.user.generalSettings;
    final userSettings = UserSettings.fromGeneralSettings(generalSettings!);
    settings.value = userSettings;
    _updateSettingsWithoutWaiting();
    // final result = _repository.getSettings(_currentUserId);
    // result.fold(() {}, (value) => settings.value = value);
  }, errorFilterFn: menoExceptionFilter);

  late final _syncFromRemote = Command.createAsyncNoParamNoResult(() async {
    final result = await _repository.syncFromRemote(_currentUserId);
    result.fold(
      (failure) => error.value = failure,
      (_) => log.d('NotesManager: syncFromRemote completed'),
    );
  }, errorFilterFn: menoExceptionFilter);

  void _updateSettingsWithoutWaiting() {
    unawaited(_repository.updateSettings(_currentUserId, settings.value));
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
