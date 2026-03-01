import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

/// Application-layer manager for the "Others Profile" screen.
class ProfileManager with MLogger implements Disposable {
  ProfileManager({required IProfileRepository repository, required Id userId})
    : _repository = repository,
      _userId = userId;

  final IProfileRepository _repository;
  final Id _userId;

  late final profile = ValueNotifier<Profile?>(null);

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _repository.getProfile(_userId);
    result.fold((failure) => throw failure, (value) => profile.value = value);
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    profile.dispose();
    fetch.dispose();
  }
}
