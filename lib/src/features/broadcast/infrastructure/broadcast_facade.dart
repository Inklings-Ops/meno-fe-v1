import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/broadcast/domain/entities/broadcast_list_entity.dart';

import '../../../services/network_service.dart';
import '../domain/domain.dart';
import 'datasources/broadcast_remote_datasource.dart';
import 'mapper/broadcast_list_mapper.dart';
import 'mapper/broadcast_mapper.dart';
import 'responses/broadcast_error.dart';

@LazySingleton(as: IBroadcastFacade)
class BroadcastFacade implements IBroadcastFacade {
  final BroadcastMapper _mapper;
  final BroadcastListMapper _listMapper;
  final BroadcastRemoteDatasource _remote;
  final NetworkService _network;

  BroadcastFacade({
    required BroadcastMapper mapper,
    required BroadcastListMapper listMapper,
    required BroadcastRemoteDatasource remote,
    required NetworkService network,
  })  : _mapper = mapper,
        _listMapper = listMapper,
        _remote = remote,
        _network = network;

  @override
  Future<Either<BroadcastException, Broadcast>> createBroadcast({
    required IBroadcastTitle title,
    IBroadcastDescription? description,
    IBroadcastArtwork? artwork,
    String? timeZone,
    List<String>? cohosts,
  }) async {
    final String broadcastTitle = title.get()!;
    final String? broadcastDescription = description?.get();
    final File? broadcastArtwork = artwork?.get();

    if (!(await _network.isConnected)) {
      return left(const BroadcastException.networkError());
    }

    try {
      /// BroadcastResponse<BroadcastDto?>
      final response = await _remote.createBroadcast(
        title: broadcastTitle,
        description: broadcastDescription,
        image: broadcastArtwork,
        cohosts: cohosts,
        timezone: timeZone,
      );

      final Broadcast broadcast = _mapper.broadcastToDomain(response.data!)!;

      return right(broadcast);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, Unit>> deleteBroadcast({
    required BroadcastId broadcastId,
  }) async {
    try {
      if (!(await _network.isConnected)) {
        return left(const BroadcastException.networkError());
      }

      await _remote.deleteBroadcast(broadcastId: broadcastId);

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
    required BroadcastId broadcastId,
    IBroadcastTitle? title,
    IBroadcastDescription? description,
    IBroadcastArtwork? image,
    String? timeZone,
    DateTime? startTime,
  }) async {
    // TODO: implement editBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<BroadcastException, List<Broadcast?>>> getBroadcasts({
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
    String? endTimeEQ,
    String? startTimeGT,
    String? startTimeLT,
    String? startTimeEQ,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const BroadcastException.networkError());
    }

    try {
      final response = await _remote.getBroadcasts(
        status: status,
        include: include,
        onlySubscriptions: onlySubscriptions,
        keywords: keywords,
        creatorId: creatorId,
        sortBy: sortBy,
        orderBy: orderBy,
        page: page,
        size: size,
        endTimeGT: endTimeGT,
        endTimeLT: endTimeLT,
        endTimeEQ: endTimeEQ,
        startTimeGT: startTimeGT,
        startTimeLT: startTimeLT,
        startTimeEQ: startTimeEQ,
      );
      final BroadcastListEntity data = _listMapper.toDomain(response.data!)!;
      return right(data.broadcasts);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, JoinBroadcastEntity>> joinBroadcast({
    required BroadcastId broadcastId,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const BroadcastException.networkError());
    }

    try {
      final response = await _remote.joinBroadcast(broadcastId: broadcastId);
      final JoinBroadcastEntity broadcast = _mapper.joinBroadcastToDomain(
        response.data!,
      )!;
      return right(broadcast);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  @override
  Future<Either<BroadcastException, Broadcast>> startBroadcast({
    required BroadcastId broadcastId,
  }) async {
    if (!(await _network.isConnected)) {
      return left(const BroadcastException.networkError());
    }

    try {
      final response = await _remote.startBroadcast(broadcastId: broadcastId);
      final Broadcast broadcast = _mapper.broadcastToDomain(response.data!)!;
      return right(broadcast);
    } on DioException catch (e) {
      final error = _getError(e);
      return left(error);
    } on TimeoutException {
      return left(const BroadcastException.timeOutError());
    }
  }

  BroadcastException _getError(DioException e) {
    Logger().w("RESPONSE => ${e.response?.data}");

    if (e.response?.data["error"].runtimeType == String) {
      Logger().w("RESPONSE MESSAGE => ${e.response?.data["message"]}");
      return BroadcastException.message(e.response?.data["message"]);
    }

    final error = BroadcastError.fromJson(e.response!.data['error']);
    Logger().w("ERROR => $error");
    String? result;

    for (String? prop in error.props) {
      result ??= prop;
    }

    if (result != null) {
      return BroadcastException.message(result);
    }

    return const BroadcastException.serverError();
  }
}
