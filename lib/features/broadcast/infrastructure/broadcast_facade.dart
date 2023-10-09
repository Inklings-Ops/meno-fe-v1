import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../services/network_service.dart';
import '../domain/domain.dart';
import 'datasources/broadcast_remote_datasource.dart';
import 'mapper/broadcast_mapper.dart';
import 'responses/broadcast_error.dart';
import 'responses/broadcast_response.dart';

@LazySingleton(as: IBroadcastFacade)
class BroadcastFacade implements IBroadcastFacade {
  final BroadcastMapper _mapper;
  final BroadcastRemoteDatasource _remote;
  final NetworkService _network;

  BroadcastFacade({
    required BroadcastMapper mapper,
    required BroadcastRemoteDatasource remote,
    required NetworkService network,
  })  : _mapper = mapper,
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
  Future<Either<BroadcastException, JoinBroadcastEntity>> joinBroadcast({
    required BroadcastId broadcastId,
  }) async {
    // TODO: implement joinBroadcast
    throw UnimplementedError();
  }

  @override
  Future<Either<BroadcastException, Broadcast>> startBroadcast({
    required BroadcastId broadcastId,
  }) async {
    // TODO: implement startBroadcast
    throw UnimplementedError();
  }

  BroadcastException _getError(DioException e) {
    String? result;
    final response = BroadcastResponse.fromJson(e.response!.data, (_) => null);

    if (response.error.runtimeType == String) {
      return BroadcastException.message(response.message!);
    }

    final error = BroadcastError.fromJson(e.response!.data['error']);
    if (error.props.isNotEmpty) {
      for (var i = 0; i < error.props.length; i++) {
        result = error.props[i].toString();
      }
    }

    if (result != null) {
      return BroadcastException.message(result);
    } else {
      return const BroadcastException.serverError();
    }
  }
}
