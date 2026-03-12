import 'dart:async';

import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';

class OnboardingService {
  OnboardingService(this._storage);

  final LocalStorage _storage;

  Future<bool> completeOnboarding() {
    return _storage.setBool(StorageKeys.onboarding, true);
  }

  bool get isOnboarded => _storage.getBool(StorageKeys.onboarding) ?? false;
}
