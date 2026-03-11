import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/profile/model/_model.dart';
import 'package:meno/features/profile/services/_services.dart';

class MyProfileManager with MLogger implements Disposable {
  MyProfileManager({
    required ProfileHttpService http,
    required ProfileLocalService local,
    required Id currentUserId,
  }) : _http = http,
       _local = local,
       _currentUserId = currentUserId;

  final ProfileHttpService _http;
  final ProfileLocalService _local;
  final Id _currentUserId;

  final _profile = ValueNotifier<Profile>(.empty);

  ValueListenable<Profile> get profile => _profile;

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    if (!_profile.value.isValid) {
      final cached = _local.getCachedProfile(_currentUserId);
      if (cached != null) _profile.value = cached;
    }

    final remoteProfile = await _http.getProfile(_currentUserId);
    _profile.value = remoteProfile;

    unawaited(_local.cacheProfile(_currentUserId, remoteProfile));
  }, errorFilterFn: menoExceptionFilter);

  void updateProfile(Profile value) => _profile.value = value;

  @override
  FutureOr<dynamic> onDispose() {
    _profile.dispose();
    fetch.dispose();
  }
}
