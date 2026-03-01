import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/shared/domain/i_broadcast_feed_source.dart';

/// Application-layer manager for the "My Profile" screen.
///
/// Responsibilities:
/// - Hydrate the current user's profile from cache + network on mount.
/// - Drive paginated broadcast tabs (recent, all) via [IBroadcastFeedSource].
/// - Expose per-tab state through lightweight [ValueNotifier]s so individual
///   tab widgets can rebuild independently — no whole-page rebuilds.
///
/// Lifecycle: registered in the user scope (singleton per session).
class MyProfileManager with MLogger implements Disposable {
  MyProfileManager(this._repository);

  final IProfileRepository _repository;

  // =========================================================================
  // PUBLIC STATE — widgets watch these
  // =========================================================================

  /// Delegates directly to the repository notifier — zero duplication.
  // ValueListenable<Profile?> get profile => _repository.myProfile.map(
  //   (option) => option.fold(() => null, (value) => value),
  // );

  ValueListenable<Option<Profile>> get profile => _repository.myProfile;

  // =========================================================================
  // COMMANDS
  // =========================================================================

  /// Pull-to-refresh — re-fetches everything.
  late final refresh = Command.createAsyncNoParamNoResult(
    _refreshProfile,
    errorFilterFn: menoExceptionFilter,
  );

  // =========================================================================
  // PRIVATE IMPLEMENTATION
  // =========================================================================

  Future<void> _refreshProfile() async {
    final result = await _repository.fetchMyProfile();
    result.fold((err) => log.w('Profile fetch error: ${err.message}'), (_) {});
  }

  // =========================================================================
  // DISPOSABLE
  // =========================================================================

  @override
  FutureOr<dynamic> onDispose() {
    refresh.dispose();
  }
}
