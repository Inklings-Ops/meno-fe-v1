import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

@Injectable(as: IBroadcastFacade)
class BroadcastFacade implements IBroadcastFacade {
  BroadcastFacade({
    required BroadcastRemoteDatasource remote,
    required BroadcastLocalDatasource local,
    required NetworkService network,
  })  : _remote = remote,
        _local = local,
        _network = network;

  final BroadcastRemoteDatasource _remote;
  final BroadcastLocalDatasource _local;
  final NetworkService _network;

  @override
  Future<Either<BroadcastException, Broadcast>> createBroadcast({
    required SingleLineString title,
    BroadcastDescription? description,
    BroadcastArtwork? artwork,
    String? timeZone,
    List<String>? cohosts,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    final titleStr = title.value.getOrElse(() => MErrorMessages.invalidBTitle);
    final descStr =
        description?.value.getOrElse(() => MErrorMessages.invalidBDesc);
    final broadcastArtwork = artwork?.value.getOrElse(() => null);

    try {
      final response = await _remote.createBroadcast(
        title: titleStr,
        description: descStr,
        image: broadcastArtwork,
        cohosts: cohosts,
        timezone: timeZone,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, Unit>> deleteBroadcast(
    Uid<Broadcast> id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final idStr = id.value.getOrElse(() => MErrorMessages.invalidBUid);
      await _remote.deleteBroadcast(broadcastId: idStr);
      return right(unit);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, Broadcast>> editBroadcast({
    required Uid<Broadcast> id,
    SingleLineString? title,
    BroadcastDescription? description,
    BroadcastArtwork? image,
    String? timeZone,
    DateTime? startTime,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    final idStr = id.value.getOrElse(() => MErrorMessages.invalidBUid);
    final titleStr = title?.value.getOrElse(() => MErrorMessages.invalidBTitle);
    final descStr =
        description?.value.getOrElse(() => MErrorMessages.invalidBDesc);
    final broadcastArtwork = image?.value.getOrElse(() => null);

    try {
      final response = await _remote.editBroadcast(
        broadcastId: idStr,
        title: titleStr,
        description: descStr,
        image: broadcastArtwork,
        timeZone: timeZone,
        startTime: startTime.toString(),
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, BroadcastListEntity>> getBroadcasts({
    String? id,
    String? status,
    String? include,
    bool? onlySubscriptions,
    String? keywords,
    String? creatorId,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
    String? endTimeGT,
    String? endTimeLT,
    bool? endTimeExist,
    String? startTimeGT,
    String? startTimeLT,
    bool? startTimeExist,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final response = await _remote.getBroadcasts(
        id: id,
        status: status,
        include: include,
        onlySubscriptions: onlySubscriptions,
        keywords: keywords,
        creatorId: creatorId,
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? 6,
        endTimeGT: endTimeGT,
        endTimeLT: endTimeLT,
        endTimeExist: endTimeExist,
        startTimeGT: startTimeGT,
        startTimeLT: startTimeLT,
        startTimeExist: startTimeExist,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, JoinBroadcastEntity>> joinBroadcast(
    Uid<Broadcast> id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final idStr = id.value.getOrElse(() => MErrorMessages.invalidBUid);
      final response = await _remote.joinBroadcast(broadcastId: idStr);
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, Broadcast>> startBroadcast(
    Uid<Broadcast> id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final idStr = id.value.getOrElse(() => MErrorMessages.invalidBUid);
      final response = await _remote.startBroadcast(broadcastId: idStr);
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, List<BroadcastParticipant>>> listeners(
    Uid<Broadcast> id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final idStr = id.value.getOrElse(() => MErrorMessages.invalidBUid);
      final response = await _remote.getListeners(broadcastId: idStr);
      final listeners =
          response.data!.broadcastListeners.map((e) => e.toDomain).toList();
      return right(listeners);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, List<BroadcastParticipant>>> liveListeners(
    Uid<Broadcast> id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final idStr = id.value.getOrElse(() => MErrorMessages.invalidBUid);
      final response = await _remote.getLiveListeners(broadcastId: idStr);
      final listeners = response.data!.map((e) => e.toDomain).toList();
      return right(listeners);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  BroadcastException _getError(DioException e) {
    final errorData = e.response?.data as Map<String, dynamic>;
    final unknownError = errorData['error'] as dynamic;
    if (unknownError.runtimeType == String) {
      return BroadcastException.message(errorData['message'] as String);
    }

    final message = errorData['error'] as Map<String, dynamic>;
    final error = BroadcastError.fromJson(message);
    String? result;

    for (final prop in error.props) {
      result ??= prop;
    }

    if (result != null) {
      return BroadcastException.message(result);
    }

    return const BroadcastException.serverError();
  }

  @override
  Future<Either<BroadcastException, BroadcastListEntity>> nowLiveBroadcasts({
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final response = await _remote.getBroadcasts(
        endTimeExist: false,
        startTimeExist: true,
        include: 'totalListeners',
        status: 'active',
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? 6,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, BroadcastListEntity>>
      recentlyLiveBroadcasts({
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
    String? endTimeGT,
    String? endTimeLT,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(days: 100));

    try {
      final response = await _remote.getBroadcasts(
        endTimeExist: true,
        include: 'totalListeners',
        status: 'active',
        sortBy: sortBy ?? 'endTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? 6,
        endTimeGT: endTimeGT ?? oneDayAgo.toIso8601String(),
        endTimeLT: endTimeLT ?? now.toIso8601String(),
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, BroadcastListEntity>> search({
    String? keywords,
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    try {
      final response = await _remote.getBroadcasts(
        keywords: keywords,
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? 6,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, BroadcastListEntity>>
      userRecentlyLiveBroadcasts({
    required Uid<User> userId,
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
    String? endTimeGT,
    String? endTimeLT,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastException.networkError());

    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(days: 100));

    try {
      final response = await _remote.getBroadcasts(
        endTimeExist: true,
        include: 'totalListeners',
        status: 'active',
        sortBy: sortBy ?? 'endTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? 6,
        endTimeGT: endTimeGT ?? oneDayAgo.toIso8601String(),
        endTimeLT: endTimeLT ?? now.toIso8601String(),
        creatorId: userId.getOr(),
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<bool> get hasSavedBroadcast => _local.hasBroadcast;

  @override
  Future<void> clearSavedBroadcastDetails() => _local.clearBroadcastDetails();

  @override
  Future<Option<Broadcast>> getSavedBroadcastDetails() async {
    final dto = await _local.getBroadcastDetails();
    if (dto == null) return none();
    return some(dto.toDomain);
  }

  @override
  Future<Option<JoinBroadcastEntity>> getSavedStreamDetails() async {
    final dto = await _local.getStreamDetails();
    if (dto == null) return none();
    return some(dto.toDomain);
  }

  @override
  Future<void> saveBroadcastDetails(Broadcast broadcast) {
    return _local.saveBroadcastDetails(broadcast.toDto);
  }

  @override
  Future<void> saveStreamDetails(JoinBroadcastEntity entity) {
    return _local.saveStreamDetails(entity.toDto);
  }
}
