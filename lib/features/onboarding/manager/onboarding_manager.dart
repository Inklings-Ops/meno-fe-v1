import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';

final class OnboardingManager implements Disposable {
  OnboardingManager(this._storage);

  final LocalStorage _storage;

  final _isOnboarded = ValueNotifier<bool>(false);

  ValueListenable<bool> get isOnboarded => _isOnboarded;

  late final initialize = Command.createSyncNoParamNoResult(() {
    final result = _storage.getBool(StorageKeys.onboarding) ?? false;
    _isOnboarded.value = result;
  });

  late final completeOnboarding = Command.createAsyncNoParamNoResult(() async {
    await _storage.setBool(StorageKeys.onboarding, true);
    _isOnboarded.value = true;
  });

  @override
  FutureOr<dynamic> onDispose() {
    _isOnboarded.dispose();
    completeOnboarding.dispose();
  }
}
