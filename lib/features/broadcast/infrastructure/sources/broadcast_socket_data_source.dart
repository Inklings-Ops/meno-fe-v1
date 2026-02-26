import 'dart:async';

import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/infrastructure/infrastructure.dart';

class BroadcastSocketDataSource with MLogger {
  const BroadcastSocketDataSource(this._client);

  final WebSocketClient _client;

  // ======================================================================
  // SOCKET EVENT ACTIONS
  // ======================================================================

  Future<dynamic> emitEndBroadcast(String broadcastId) async {
    return _client.emitWithAck(SocketEvent.endBroadcast, {
      'broadcastId': broadcastId,
    });
  }

  Future<dynamic> emitStartedBroadcast(String broadcastId) async {
    return _client.emitWithAck(SocketEvent.startedBroadcast, {
      'broadcastId': broadcastId,
    });
  }

  Future<dynamic> emitJoinedBroadcast(String broadcastId) async {
    return _client.emitWithAck(SocketEvent.joinedBroadcast, {
      'broadcastId': broadcastId,
    });
  }

  Future<dynamic> emitLeaveBroadcast(String broadcastId) async {
    return _client.emitWithAck(SocketEvent.leaveBroadcast, {
      'broadcastId': broadcastId,
    });
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
        subscription = _client.on(SocketEvent.newBroadcast, (dynamic data) {
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
        subscription = _client.on(SocketEvent.endedBroadcast, (dynamic data) {
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
        subscription = _client.on(SocketEvent.hostDisconnected, (dynamic data) {
          try {
            log.i('BroadcastSocketDataSource: Host disconnected: $data');
            controller.add(data);
          } catch (e) {
            log.e('BroadcastSocketDataSource: Error hostDisconnected - $e');
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
        subscription = _client.on(SocketEvent.hostReconnected, (dynamic data) {
          try {
            log.i('BroadcastSocketDataSource: Host reconnected: $data');
            controller.add(data);
          } catch (e) {
            log.e('BroadcastSocketDataSource: Error hostReconnected - $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Subscribe to this socket event to be notified when a new [ParticipantDto]
  /// joins the currently live broadcast
  Stream<ParticipantDto> get onParticipantJoined {
    late final StreamController<ParticipantDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<ParticipantDto>.broadcast(
      onListen: () {
        subscription = _client.on(SocketEvent.newBroadcastListener, (
          dynamic data,
        ) {
          try {
            final dto = ParticipantDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing newBroadcastListener: $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Subscribe to this socket event to be notified when a [ParticipantDto]
  /// leaves a currently live broadcast
  Stream<ParticipantDto> get onParticipantLeft {
    late StreamController<ParticipantDto> controller;
    SocketSubscription? subscription;

    controller = StreamController<ParticipantDto>.broadcast(
      onListen: () {
        subscription = _client.on(SocketEvent.broadcastListenerLeft, (
          dynamic data,
        ) {
          try {
            final dto = ParticipantDto.fromJson(data);
            controller.add(dto);
          } catch (e) {
            log.e('Error parsing newBroadcastListener: $e');
          }
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  Stream<void> get onReconnected {
    // Filter the connection state stream to only emit on 'connected'
    return _client.connectionState
        .where((state) => state == SocketConnectionState.connected)
        .map((_) {});
  }
}
