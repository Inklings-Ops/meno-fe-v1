import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/onboarding/services/_services.dart';

final class OnboardingManager extends ChangeNotifier implements Disposable {
  OnboardingManager(this._service);

  final OnboardingService _service;

  final _isOnboarded = ValueNotifier<bool>(false);

  ValueListenable<bool> get isOnboarded => _isOnboarded;

  late final initialize = Command.createSyncNoParamNoResult(() {
    _isOnboarded.value = _service.isOnboarded;
    notifyListeners();
  });

  late final completeOnboarding = Command.createAsyncNoParamNoResult(() async {
    if (_isOnboarded.value) return;

    _isOnboarded.value = true;
    notifyListeners();

    await _service.completeOnboarding();
  });

  @override
  FutureOr<dynamic> onDispose() {
    _isOnboarded.dispose();
    completeOnboarding.dispose();
  }
}
