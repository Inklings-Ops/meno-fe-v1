import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';

class BroadcastRemoteDataSource with MenoLogger {
  const BroadcastRemoteDataSource({
    required ApiClient api,
    required WebSocketClient socket,
  }) : _api = api,
       _socket = socket;

  final ApiClient _api;
  final WebSocketClient _socket;

  Future<BroadcastDto?> createBroadcast({
    required String title,
    required String description,
    String? timezone,
    List<String>? cohosts,
    File? image,
    CancelToken? cancelToken,
  }) async {
    final data = FormData();

    data.fields.add(MapEntry('title', title));

    data.fields.add(MapEntry('description', description));

    cohosts?.forEach((i) => data.fields.add(MapEntry('cohosts', i)));

    if (timezone != null) data.fields.add(MapEntry('timezone', timezone));

    if (image != null) {
      final imageData = MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      );
      data.files.add(MapEntry('image', imageData));
    }

    return _api.upload(
      '/broadcasts',
      formData: data,
      fromJson: BroadcastDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<BroadcastDto?> startBroadcast(
    String broadcastId, {
    CancelToken? cancelToken,
  }) async {
    return _api.post(
      '/broadcasts/$broadcastId/start',
      fromJson: BroadcastDto.fromJson,
      cancelToken: cancelToken,
    );
  }

  Future<dynamic> getBroadcasts(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) async {
    return _api.get(
      '/broadcasts',
      queryParameters: queryParameters,
      fromJson: (json) => json,
      cancelToken: cancelToken,
    );
  }

  // ======================================================================
  // STREAMS
  // ======================================================================
  /// Stream of new broadcasts
  Stream<BroadcastDto> get onNewBroadcast {
    late final StreamController<BroadcastDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<BroadcastDto>.broadcast(
      onListen: () {
        subscription = _socket.on(SocketEvent.newBroadcast, (dynamic data) {
          try {
            final dto = BroadcastDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing newBroadcast: $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Stream of ended broadcasts
  Stream<EndedBroadcastDto> get onEndedBroadcast {
    late final StreamController<EndedBroadcastDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<EndedBroadcastDto>.broadcast(
      onListen: () {
        subscription = _socket.on(SocketEvent.endedBroadcast, (dynamic data) {
          try {
            final dto = EndedBroadcastDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing endedBroadcast: $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Stream of host disconnection events
  Stream<dynamic> get onHostDisconnected {
    late final StreamController<dynamic> controller;
    SocketSubscription? subscription;

    controller = StreamController<dynamic>.broadcast(
      onListen: () {
        subscription = _socket.on(SocketEvent.hostDisconnected, (dynamic data) {
          try {
            log.i('BroadcastRemoteDataSource: Host disconnected: $data');
            controller.add(data);
          } catch (e) {
            log.e('BroadcastRemoteDataSource: Error hostDisconnected - $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Stream of host reconnection events
  Stream<dynamic> get onHostReconnected {
    late final StreamController<dynamic> controller;
    SocketSubscription? subscription;

    controller = StreamController<dynamic>.broadcast(
      onListen: () {
        subscription = _socket.on(SocketEvent.hostReconnected, (dynamic data) {
          try {
            log.i('BroadcastRemoteDataSource: Host reconnected: $data');
            controller.add(data);
          } catch (e) {
            log.e('BroadcastRemoteDataSource: Error hostReconnected - $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  Stream<void> get onReconnected {
    // Filter the connection state stream to only emit on 'connected'
    return _socket.connectionState
        .where((state) => state == SocketConnectionState.connected)
        .map((_) {});
  }
}
