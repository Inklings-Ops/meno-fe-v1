import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/core.dart' show BaseResponse, PaginatedList;
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart' show NetworkService;
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
    required MultiLineString description,
    ImageFile? artwork,
    String? timeZone,
    List<String>? cohosts,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    final titleStr = title.getOrCrash();
    final descStr = description.getOrCrash();
    final image = artwork?.getOrNull();

    try {
      final response = await _remote.createBroadcast(
        title: titleStr,
        description: descStr,
        image: image,
        cohosts: cohosts,
        timezone: timeZone,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, Unit>> deleteBroadcast(
    ID id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    try {
      final idStr = id.getOrCrash();
      await _remote.deleteBroadcast(broadcastId: idStr);
      return right(unit);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, Broadcast>> editBroadcast({
    required ID id,
    SingleLineString? title,
    MultiLineString? description,
    ImageFile? image,
    String? timeZone,
    DateTime? startTime,
  }) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    final idStr = id.getOrCrash();
    final titleStr = title?.getOrNull();
    final descStr = description?.getOrNull();
    final artwork = image?.getOrNull();

    try {
      final response = await _remote.editBroadcast(
        broadcastId: idStr,
        title: titleStr,
        description: descStr,
        image: artwork,
        timeZone: timeZone,
        startTime: startTime.toString(),
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, PaginatedList<Broadcast?>>> getBroadcasts({
    required String sortBy,
    required OrderBy orderBy,
    ID? id,
    String? status,
    String? include,
    bool? onlySubscriptions,
    String? keywords,
    ID? creatorId,
    int page = 1,
    int size = 8,
    String? endTimeGT,
    String? endTimeLT,
    bool? endTimeExist,
    String? startTimeGT,
    String? startTimeLT,
    bool? startTimeExist,
    CancelToken? cancelToken,
  }) async {
    // final isConnected = await _network.isConnected;
    // if (!isConnected) return left(const BroadcastNetworkException());

    try {
      final response = await _remote.getBroadcasts(
        status: status,
        include: include,
        id: id?.getOrNull(),
        onlySubscriptions: onlySubscriptions,
        keywords: keywords,
        creatorId: creatorId?.getOrNull(),
        sortBy: sortBy,
        orderBy: orderBy.name,
        page: page,
        size: size,
        endTimeGT: endTimeGT,
        endTimeLT: endTimeLT,
        endTimeExist: endTimeExist,
        startTimeGT: startTimeGT,
        startTimeLT: startTimeLT,
        startTimeExist: startTimeExist,
      );
      final data = response.data!;
      final paginatedList = PaginatedList(
        items: data.broadcasts.map((dto) => dto?.toDomain).toList(),
        currentPage: data.currentPage,
        totalItems: data.totalItems,
        totalPages: data.totalPages,
      );
      return Right(paginatedList);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, Broadcast>> joinBroadcast(
    ID id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    try {
      final idStr = id.getOrCrash();
      final response = await _remote.joinBroadcast(broadcastId: idStr);
      final data = response.data!;
      final broadcastWithoutToken = data.broadcast.toDomain;
      final broadcastWithToken = broadcastWithoutToken.copyWith(
        broadcastToken: data.broadcastToken,
      );
      return right(broadcastWithToken);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, Broadcast>> startBroadcast(
    ID id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    try {
      final idStr = id.getOrCrash();
      final response = await _remote.startBroadcast(broadcastId: idStr);
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, PaginatedList<Participant?>>> listeners(
    ID id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    try {
      final response = await _remote.getListeners(broadcastId: id.getOrCrash());
      final data = response.data!;
      final paginatedList = PaginatedList(
        items: data.participants.map((dto) => dto?.toDomain).toList(),
        currentPage: data.currentPage,
        totalItems: data.totalItems,
        totalPages: data.totalPages,
      );
      return right(paginatedList);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<Either<BroadcastException, List<Participant?>>> liveListeners(
    ID id,
  ) async {
    final isConnected = await _network.isConnected;
    if (!isConnected) return left(const BroadcastNetworkException());

    try {
      final idStr = id.getOrCrash();
      final response = await _remote.getLiveListeners(broadcastId: idStr);
      final listeners = response.data!.map((e) => e.toDomain).toList();
      return right(listeners);
    } on DioException catch (e) {
      final error = _handleDioException(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastTimeoutException());
    }
  }

  @override
  Future<void> clearSavedBroadcastDetails() => _local.clearBroadcastDetails();

  @override
  Future<Option<Broadcast>> getSavedBroadcastDetails() async {
    final dto = await _local.getBroadcastDetails();
    if (dto == null) return none();
    return some(dto.toDomain);
  }

  @override
  Future<void> saveBroadcastDetails(Broadcast broadcast) {
    return _local.saveBroadcastDetails(broadcast.toDto);
  }
}

BroadcastException _handleDioException(DioException error) {
  final errorData = error.response?.data;

  if (errorData == null) return const BroadcastUnknownException();

  final baseError = errorData as Map<String, dynamic>;
  final base = BaseResponse.fromJson(baseError, (_) => null);

  return switch (base.error) {
    final Map<String, dynamic> errors => BroadcastValidationException(errors),
    _ => BroadcastExceptionWithMessage(base.message ?? 'Unknown error'),
  };
}
