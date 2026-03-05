import 'dart:async';

import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/model/dtos/dtos.dart';

final class BroadcastSocketService {
  const BroadcastSocketService(this._client);

  final SocketClient _client;

  // ======================================================================
  // SOCKET EVENT ACTIONS
  // ======================================================================

  Future<dynamic> emitEndBroadcast(String broadcastId) async {
    return _client.emitWithAck(.endBroadcast, {'broadcastId': broadcastId});
  }

  Future<dynamic> emitStartedBroadcast(String broadcastId) async {
    return _client.emitWithAck(.startedBroadcast, {'broadcastId': broadcastId});
  }

  Future<dynamic> emitJoinedBroadcast(String broadcastId) async {
    return _client.emitWithAck(.joinedBroadcast, {'broadcastId': broadcastId});
  }

  Future<dynamic> emitLeaveBroadcast(String broadcastId) async {
    return _client.emitWithAck(.leaveBroadcast, {'broadcastId': broadcastId});
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
        subscription = _client.on(.newBroadcast, (dynamic data) {
          final dto = BroadcastDto.fromJson(data);
          controller.add(dto);
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
        subscription = _client.on(.endedBroadcast, (dynamic data) {
          final dto = EndedBroadcastDto.fromJson(data);
          controller.add(dto);
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
        subscription = _client.on(.hostDisconnected, controller.add);
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
        subscription = _client.on(.hostReconnected, controller.add);
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
        subscription = _client.on(.newBroadcastListener, (dynamic data) {
          final dto = ParticipantDto.fromJson(data);
          controller.add(dto);
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
        subscription = _client.on(.broadcastListenerLeft, (dynamic data) {
          final dto = ParticipantDto.fromJson(data);
          controller.add(dto);
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
