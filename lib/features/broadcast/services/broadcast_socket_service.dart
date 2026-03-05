import 'dart:async';

import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/broadcast/model/model.dart';

final class BroadcastSocketService {
  const BroadcastSocketService(this._client);

  final SocketClient _client;

  // ======================================================================
  // SOCKET EVENT ACTIONS
  // ======================================================================

  Future<dynamic> emitEndBroadcast(Id broadcastId) async {
    return _client.emitWithAck(.endBroadcast, {
      'broadcastId': broadcastId.getOrCrash(),
    });
  }

  Future<dynamic> emitStartedBroadcast(Id broadcastId) async {
    return _client.emitWithAck(.startedBroadcast, {
      'broadcastId': broadcastId.getOrCrash(),
    });
  }

  Future<dynamic> emitJoinedBroadcast(Id broadcastId) async {
    return _client.emitWithAck(.joinedBroadcast, {
      'broadcastId': broadcastId.getOrCrash(),
    });
  }

  Future<dynamic> emitLeaveBroadcast(Id broadcastId) async {
    return _client.emitWithAck(.leaveBroadcast, {
      'broadcastId': broadcastId.getOrCrash(),
    });
  }

  // ======================================================================
  // STREAMS
  // ======================================================================
  /// Stream of new broadcasts
  Stream<Broadcast> get onNewBroadcast {
    late final StreamController<Broadcast> controller;
    SocketSubscription? subscription;

    controller = StreamController<Broadcast>.broadcast(
      onListen: () {
        subscription = _client.on(.newBroadcast, (dynamic data) {
          final dto = BroadcastDto.fromJson(data);
          controller.add(dto.toDomain);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Stream of ended broadcasts
  Stream<EndedBroadcast> get onEndedBroadcast {
    late final StreamController<EndedBroadcast> controller;
    SocketSubscription? subscription;

    controller = StreamController<EndedBroadcast>.broadcast(
      onListen: () {
        subscription = _client.on(.endedBroadcast, (dynamic data) {
          final dto = EndedBroadcastDto.fromJson(data);
          controller.add(dto.toDomain);
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

  /// Subscribe to this socket event to be notified when a new [Participant]
  /// joins the currently live broadcast
  Stream<Participant> get onParticipantJoined {
    late final StreamController<Participant> controller;
    SocketSubscription? subscription;

    controller = StreamController<Participant>.broadcast(
      onListen: () {
        subscription = _client.on(.newBroadcastListener, (dynamic data) {
          final dto = ParticipantDto.fromJson(data);
          controller.add(dto.toDomain);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  /// Subscribe to this socket event to be notified when a [Participant]
  /// leaves a currently live broadcast
  Stream<Participant> get onParticipantLeft {
    late StreamController<Participant> controller;
    SocketSubscription? subscription;

    controller = StreamController<Participant>.broadcast(
      onListen: () {
        subscription = _client.on(.broadcastListenerLeft, (dynamic data) {
          final dto = ParticipantDto.fromJson(data);
          controller.add(dto.toDomain);
        });
      },
      onCancel: () => subscription?.cancel(),
    );

    return controller.stream;
  }

  Stream<void> get onReconnected {
    // Filter the connection state stream to only emit on 'connected'
    return _client.connectionState.where((s) => s == .connected).map((_) {});
  }
}
