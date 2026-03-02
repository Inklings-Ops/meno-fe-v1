import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/domain/domain.dart';

class MyProfileManager with MLogger implements Disposable {
  MyProfileManager(this._repository);

  final IProfileRepository _repository;

  ValueListenable<Option<Profile>> get profile => _repository.myProfile;

  /// Pull-to-refresh — re-fetches everything.
  late final refresh = Command.createAsyncNoParamNoResult(() async {
    final result = await _repository.fetchMyProfile();
    result.fold((err) => log.w('Profile fetch error: ${err.message}'), (_) {});
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    refresh.dispose();
  }
}
