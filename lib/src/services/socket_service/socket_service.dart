import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../../core/env/env.dart';
import '../../features/broadcast/domain/domain.dart';
import '../../features/broadcast/infrastructure/dtos/dtos.dart';
import '../../features/broadcast/infrastructure/mapper/broadcast_mapper.dart';
import '../../shared/m_keys.dart';
import '../secure_storage_service.dart';
import 'socket_event.dart';

part 'socket_service.freezed.dart';
part 'socket_service.g.dart';
part 'socket_state.dart';

@riverpod
ValueNotifier<SocketState> socket(SocketRef ref) {
  final notifier = ValueNotifier(ref.watch(socketServiceProvider));

  ref.onDispose(notifier.dispose);

  notifier.addListener(ref.notifyListeners);

  return notifier;
}

@riverpod
Stream<SocketState> socketStream(SocketStreamRef ref) async* {
  yield ref.watch(socketServiceProvider);
}

@riverpod
List<Participant?> liveParticipants(LiveParticipantsRef ref) {
  return ref.watch(socketServiceProvider).participants;
}

@riverpod
class SocketService extends _$SocketService {
  final Logger _log = Logger();
  final SecureStorageService _storage = SecureStorageService();
  final BroadcastMapper _mapper = BroadcastMapper();

  late socket_io.Socket? socket;

  @override
  SocketState build() {
    initialize();
    return SocketState.initial();
  }

  void endBroadcast(String broadcastId) {
    return socket?.emitWithAck(
      SocketEvent.endBroadcast,
      {'broadcastId': broadcastId},
      ack: (data) => state = state.copyWith(isLive: false),
    );
  }

  void getLiveBroadcast(String broadcastId) {
    if (socket == null || !socket!.connected) {
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.getLiveBroadcast,
      {"broadcastId": broadcastId},
      ack: (data) {
        final BroadcastDto dto = BroadcastDto.fromJson(data);
        final Broadcast? broadcast = _mapper.broadcastToDomain(dto);
        state = state.copyWith(liveBroadcast: broadcast ?? Broadcast.empty());
      },
    );
  }

  void getLiveBroadcasts() {
    if (socket == null || !socket!.connected) {
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.getLiveBroadcasts,
      {},
      ack: (data) async {
        final res = (jsonDecode(jsonEncode(data))['data']);
        if (res != null) {
          final list = (res as List);
          final dtos = list.map((b) => BroadcastDto.fromJson(b)).toList();
          final broadcasts = dtos.map(_mapper.broadcastToDomain).toList();
          state = state.copyWith(liveBroadcasts: broadcasts);
        }
      },
    );
  }

  Future<void> initialize() async {
    final String? token = await _storage.read(MKeys.currentUserTokenKey);
    socket = socket_io.io(
      Env.menoApiUrl,
      socket_io.OptionBuilder()
          .setTransports(["websocket"])
          .setQuery({"token": token})
          .enableAutoConnect()
          .build(),
    );
    socket?.connect();
    socketGlobalListeners();
  }

  dynamic onConnect(_) => _log.i('Socket Connected');

  dynamic onDisconnect(_) => _log.i('Socket Disconnected');

  dynamic onEndedBroadcast(dynamic data) {
    _log.i('Ended broadcast... => $data');
    getLiveBroadcasts();
    state = state.copyWith(liveBroadcast: Broadcast.empty());
  }

  dynamic onError(msg) => _log.i('Socket Error: ${msg.toString()}');

  dynamic onNewBroadcast(dynamic data) async {
    _log.i('New broadcast... => $data');
    final Map<String, dynamic> decodedData = jsonDecode(jsonEncode(data));
    final BroadcastDto dto = BroadcastDto.fromJson(decodedData);
    final Broadcast? broadcast = _mapper.broadcastToDomain(dto);

    final liveBroadcasts = List<Broadcast?>.from(state.liveBroadcasts);
    liveBroadcasts.add(broadcast);
    state = state.copyWith(liveBroadcasts: liveBroadcasts);

    getLiveBroadcasts();
  }

  dynamic onNewBroadcastListener(dynamic data) {
    _log.i('New Broadcast Listener... => $data');
    final dto = ParticipantDto.fromJson(data);
    final newParticipant = Participant(
      id: dto.id,
      fullName: dto.fullName,
      imageUrl: dto.imageUrl,
    );
    final participants = List<Participant?>.from(state.participants);
    participants.add(newParticipant);
    state = state.copyWith(participants: participants);
  }

  dynamic onNumberOfLiveBroadcasts(dynamic data) {
    final int numberOfParticipants = jsonDecode(jsonEncode(data));
    state = state.copyWith(numberOfParticipants: numberOfParticipants);
  }

  dynamic socketGlobalListeners() {
    socket?.on(SocketEvent.connect, onConnect);
    socket?.on(SocketEvent.disconnect, onDisconnect);
    socket?.on(SocketEvent.error, onError);
    socket?.on(SocketEvent.newBroadcast, onNewBroadcast);
    socket?.on(SocketEvent.endedBroadcast, onEndedBroadcast);
    socket?.on(SocketEvent.newBroadcastListener, onNewBroadcastListener);
    socket?.on(SocketEvent.numberOfLiveListeners, onNumberOfLiveBroadcasts);
  }

  void startBroadcast(String broadcastId) {
    if (socket == null || !socket!.connected) {
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.startedBroadcast,
      {"broadcastId": broadcastId},
      ack: (data) => state = state.copyWith(isLive: true),
    );
  }
}
