import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/discover/discover.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';

import 'discover_error.dart';

const int globalPaginationSize = 6;

@Injectable(as: IDiscoverFacade)
class DiscoverFacade implements IDiscoverFacade {
  final DiscoverRemoteDatasource _remote;
  final NetworkService _network;

  const DiscoverFacade({
    required DiscoverRemoteDatasource remote,
    required NetworkService network,
  })  : _remote = remote,
        _network = network;

  @override
  Future<Either<DiscoverException, DiscoverResult>> fetchBroadcasts({
    String? include,
    String? sortBy,
    String? orderBy,
    int? page,
    int? size,
    String? status,
    bool? onlySubscriptions,
    String? keywords,
    String? creatorId,
    String? endTime,
    String? endTimeGT,
    String? endTimeLT,
    String? startTime,
    String? startTimeGT,
    String? startTimeLT,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const DiscoverException.networkError());
    }
    try {
      final response = await _remote.fetchBroadcasts(
        include: include ?? 'totalListeners',
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? globalPaginationSize,
        status: status,
        onlySubscriptions: onlySubscriptions,
        keywords: keywords,
        creatorId: creatorId,
        endTime: endTime,
        endTimeGT: endTimeGT,
        endTimeLT: endTimeLT,
        startTime: startTime,
        startTimeGT: startTimeGT,
        startTimeLT: startTimeLT,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const DiscoverException.timeOutError());
    }
  }

  @override
  Future<Either<DiscoverException, DiscoverResult>> fetchNowLive({
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const DiscoverException.networkError());
    }
    try {
      final response = await _remote.fetchNowLive(
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? globalPaginationSize,
        include: 'totalListeners',
        endTime: DateTime.now().toString(),
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const DiscoverException.timeOutError());
    }
  }

  @override
  Future<Either<DiscoverException, DiscoverResult>> fetchRecentlyLive({
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
    String? endTimeGT,
    String? endTimeLT,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const DiscoverException.networkError());
    }

    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(days: 100));

    try {
      final response = await _remote.fetchRecentlyLive(
        include: 'totalListeners',
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? globalPaginationSize,
        endTimeGT: endTimeGT ?? oneDayAgo.toIso8601String(),
        endTimeLT: endTimeLT ?? now.toIso8601String(),
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const DiscoverException.timeOutError());
    }
  }

  @override
  Future<Either<DiscoverException, DiscoverResult>> search({
    String? keywords,
    int? page,
    int? size,
    String? sortBy,
    String? orderBy,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const DiscoverException.networkError());
    }
    try {
      final response = await _remote.search(
        keywords: keywords,
        sortBy: sortBy ?? 'startTime',
        orderBy: orderBy ?? 'DESC',
        page: page ?? 1,
        size: size ?? globalPaginationSize,
      );
      return right(response.data!.toDomain);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const DiscoverException.timeOutError());
    }
  }
}

DiscoverException _getError(DioException e) {
  if (e.response?.data['error'].runtimeType == String) {
    return DiscoverException.message(e.response?.data['message']);
  }

  final error = DiscoverError.fromJson(e.response!.data['error']);
  String? result;

  for (String? prop in error.props) {
    result ??= prop;
  }

  if (result != null) {
    return DiscoverException.message(result);
  }

  return const DiscoverException.serverError();
}
