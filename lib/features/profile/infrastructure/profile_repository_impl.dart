import 'dart:async';

import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:fpdart/fpdart.dart' show Either, Left, Right, Unit, unit;
import 'package:meno/core/core.dart';
import 'package:meno/features/profile/domain/domain.dart';
import 'package:meno/features/profile/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/domain.dart';

/// Concrete implementation of [IProfileRepository].
///
/// Architecture:
/// - [ProfileLocalDataSource]  — SharedPreferences cache (instant reads)
/// - [ProfileHttpDataSource]   — REST API calls (authoritative data)
///
/// On [fetchMyProfile]:
///    → serve local cache
///    → emit to notifier
///    → refresh from network in background
///    → emit again
///    → persist new value locally.
///
/// Subscriber cache reasoning (why we do NOT cache subscribers):
///  Subscriber lists belong to a *browse* context (paginated, searchable)
///  rather than an *owned* context. They change constantly (any user can
///  subscribe at any time), so a stale cache would mislead more than help.
///  The [getSubscribers] / [getSubscriptions] methods remain network-only.
///
final class ProfileRepositoryImpl implements IProfileRepository, Disposable {
  ProfileRepositoryImpl({
    required ProfileHttpDataSource http,
    required ProfileLocalDataSource local,
  }) : _http = http,
       _local = local;

  final ProfileHttpDataSource _http;
  final ProfileLocalDataSource _local;

  // =========================================================================
  // NOTIFIERS  — UI watches these
  // =========================================================================

  final _myProfile = ValueNotifier<Profile?>(null);

  @override
  ValueListenable<Profile?> get myProfile => _myProfile;

  // =========================================================================
  // OWN PROFILE
  // =========================================================================

  @override
  Future<Either<MenoException, Profile>> fetchMyProfile(Id userId) async {
    final rawId = userId.getOrCrash();

    // Seed from cache for instant render.
    final cached = _local.getCachedProfile(rawId);
    if (cached != null) _myProfile.value = cached.toDomain;

    // Refresh from network.
    try {
      final dto = await _http.getProfile(rawId);
      if (dto == null) {
        // Cache was our best shot; surface a soft error but keep cached value.
        return const Left(MenoException('Profile not found'));
      }

      final profile = dto.toDomain;
      _myProfile.value = profile;

      // Persist fresh data locally (fire-and-forget).
      unawaited(_local.cacheProfile(rawId, dto));

      return Right(profile);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Profile>> getProfile(
    Id userId, {
    CancelToken? cancelToken,
  }) async {
    try {
      final dto = await _http.getProfile(
        userId.getOrCrash(),
        cancelToken: cancelToken,
      );
      if (dto == null) return const Left(MenoException('Profile not found'));
      return Right(dto.toDomain);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Profile>> editProfile({
    required Id id,
    SingleLineString? fullName,
    MultiLineString? bio,
    ImageInput? image,
  }) async {
    try {
      final dto = await _http.editProfile(
        userId: id.getOrCrash(),
        fullName: fullName?.getOrNull(),
        bio: bio?.getOrNull(),
        image: (image?.getOrNull() as LocalImage?)?.file,
      );

      final profile = dto.toDomain;

      _myProfile.value = profile;
      unawaited(_local.cacheProfile(id.getOrCrash(), dto));

      return Right(profile);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  // =========================================================================
  // BROWSE
  // =========================================================================

  @override
  Future<Either<MenoException, PagedList<Profile?>>> getProfiles({
    OrderBy orderBy = OrderBy.asc,
    SortBy sortBy = SortBy.fullName,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final params = <String, dynamic>{
        'orderBy': orderBy.value,
        'sortBy': sortBy.value,
        'page': pagination.page,
        'size': pagination.size,
        if (keywords != null && keywords.isNotEmpty) 'keywords': keywords,
        if (includeSubscribed) 'include': 'subscribed',
      };

      final result = await _http.getProfiles(params, cancelToken: cancelToken);
      return Right(_toProfilePagedList(result));
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  // =========================================================================
  // SUBSCRIBERS / SUBSCRIPTIONS
  // These are browse/search contexts — intentionally network-only.
  // =========================================================================

  @override
  Future<Either<MenoException, PagedList<Profile?>>> getSubscribers({
    required Id subscriptionId,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final params = <String, dynamic>{
        'subscriptionId': subscriptionId.getOrCrash(),
        'page': pagination.page,
        'size': pagination.size,
        if (keywords != null && keywords.isNotEmpty) 'keywords': keywords,
        if (includeSubscribed) 'include': 'subscribed',
      };

      final result = await _http.getSubscribers(
        params,
        cancelToken: cancelToken,
      );
      return Right(_toProfilePagedList(result));
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, PagedList<Profile?>>> getSubscriptions({
    required Id subscriberId,
    PaginationParams pagination = const PaginationParams(),
    String? keywords,
    bool includeSubscribed = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final params = <String, dynamic>{
        'subscriberId': subscriberId.getOrCrash(),
        'page': pagination.page,
        'size': pagination.size,
        if (keywords != null && keywords.isNotEmpty) 'keywords': keywords,
        if (includeSubscribed) 'include': 'subscribed',
      };

      final result = await _http.getSubscriptions(
        params,
        cancelToken: cancelToken,
      );
      return Right(_toProfilePagedList(result));
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> subscribe(Id id) async {
    try {
      await _http.subscribe(id.getOrCrash());

      // Optimistically patch myProfile if the target is somehow the current
      // user (edge case guard) — more relevant for social graph updates via
      // subscriber count.
      _patchSubscriberCount(increment: true);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> unsubscribe(Id id) async {
    try {
      await _http.unsubscribe(id.getOrCrash());
      _patchSubscriberCount(increment: false);
      return const Right(unit);
    } catch (error) {
      if (error is MenoException) return Left(error);
      return Left(UnknownException(error.toString()));
    }
  }

  // =========================================================================
  // DISPOSABLE
  // =========================================================================

  @override
  FutureOr<dynamic> onDispose() {
    _myProfile.dispose();
  }

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  PagedList<Profile?> _toProfilePagedList(PagedList<ProfileDto?> result) {
    return PagedList(
      items: result.items.map((d) => d?.toDomain).toList(),
      currentPage: result.currentPage,
      totalItems: result.totalItems,
      totalPages: result.totalPages,
    );
  }

  /// Increments or decrements [Profile.numberOfSubscriptions] locally.
  ///
  /// The server is authoritative; [fetchMyProfile] will correct any drift
  /// the next time the profile screen opens.
  void _patchSubscriberCount({required bool increment}) {
    final current = _myProfile.value;
    if (current == null) return;

    _myProfile.value = current.copyWith(
      numberOfSubscriptions: increment
          ? current.numberOfSubscriptions + 1
          : (current.numberOfSubscriptions - 1).clamp(
              0,
              double.maxFinite.toInt(),
            ),
    );
  }
}
