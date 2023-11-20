import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/auth/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../../core/env/env.dart';
import '../../dependency_injector/injector.dart';
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
Future<List<Participant?>> getParticipants(
  GetParticipantsRef ref,
  String broadcastId,
) async {
  final notifier = ref.read(socketServiceProvider.notifier);

  final data = await notifier.emit(
    SocketEvent.getBroadcastListeners,
    requestData: {"broadcastId": broadcastId},
  );

  final res = (jsonDecode(jsonEncode(data))['data']);

  if (res != null) {
    final list = (res as List);
    final dtos = list.map((b) => ParticipantDto.fromJson(b)).toList();
    return dtos.map(BroadcastMapper().participantToDomain).toList();
  }

  return [];
}

@riverpod
List<Participant?> liveParticipants(LiveParticipantsRef ref) {
  return ref.watch(socketServiceProvider).participants;
}

@Riverpod(keepAlive: true)
class SocketService extends _$SocketService {
  final Logger _log = Logger();
  final BroadcastMapper _mapper = BroadcastMapper();

  @override
  SocketState build() {
    Future.wait([initialize()]);
    return SocketState.initial(loading: true);
  }

  socket_io.Socket? socket;

  Future<void> initialize() async {
    final SecureStorageService storage = SecureStorageService();
    final String? token = await storage.read(MKeys.currentUserTokenKey);

    socket = socket_io.io(
      Env.menoApiUrl,
      socket_io.OptionBuilder()
          .setTransports(["websocket"])
          .setQuery({"token": token})
          .enableAutoConnect()
          .build(),
    );

    socketGlobalListeners();
  }

  dynamic socketGlobalListeners() {
    socket?.on(SocketEvent.connect, onConnect);
    socket?.on(SocketEvent.disconnect, onDisconnect);
    socket?.on(SocketEvent.error, onSocketError);
    socket?.on(SocketEvent.newBroadcast, onNewBroadcast);
    socket?.on(SocketEvent.endedBroadcast, onEndedBroadcast);
    socket?.on(SocketEvent.newBroadcastListener, onNewBroadcastListener);
    socket?.on(SocketEvent.numberOfLiveListeners, onNumberOfLiveBroadcasts);
  }

  dynamic onConnect(_) {
    _log.i('Socket Connected');
    getLiveBroadcasts();
  }

  dynamic onDisconnect(_) => _log.i('Socket Disconnected');

  dynamic onSocketError(msg) => _log.i('Socket Error: ${msg.toString()}');

  Future<dynamic> emit(String event, {dynamic requestData}) async {
    if (socket == null || !socket!.connected) {
      state = state.copyWith(loading: true);
      return null;
    }

    Completer<dynamic> completer = Completer();

    socket?.emitWithAck(
      event,
      requestData ?? {},
      ack: (data) {
        state = state.copyWith(loading: false);
        completer.complete(data);
      },
    );

    return completer.future;
  }

  void endBroadcast(String broadcastId) {
    if (socket == null || !socket!.connected) {
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.endBroadcast,
      {"broadcastId": broadcastId},
      ack: (data) => state = SocketState.initial(),
    );
  }

  dynamic getLiveBroadcasts() {
    if (socket == null || !socket!.connected) {
      state = state.copyWith(loading: true);
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.getLiveBroadcasts,
      {},
      ack: (data) async {
        final userId = (await di<IAuthFacade>().user)!.id;

        if (state.liveBroadcasts.isEmpty) {
          state = state.copyWith(loading: true);
        }
        final res = (jsonDecode(jsonEncode(data))['data']);
        if (res != null) {
          final list = (res as List);
          final dtos = list.map((b) => BroadcastDto.fromJson(b)).toList();
          final broadcasts = dtos.map(_mapper.broadcastToDomain).toList();

          RootIsolateToken rToken = RootIsolateToken.instance!;
          final filteredList = await runIsolate(rToken, broadcasts, userId);

          state = state.copyWith(liveBroadcasts: filteredList, loading: false);
        }
      },
    );
  }

  void joinBroadcast(String broadcastId) {
    state = state.copyWith(loading: true);

    if (socket == null || !socket!.connected) {
      state = state.copyWith(loading: false);
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.joinBroadcast,
      {"broadcastId": broadcastId},
      ack: (data) => state = state.copyWith(isStreaming: true, loading: false),
    );
  }

  void leaveBroadcast(String broadcastId) {
    if (socket == null || !socket!.connected) {
      state = state.copyWith(loading: true);
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.leaveBroadcast,
      {"broadcastId": broadcastId},
      ack: (data) => state = state.copyWith(isStreaming: false, loading: false),
    );
  }

  void startBroadcast(String broadcastId) {
    if (socket == null || !socket!.connected) {
      state = state.copyWith(loading: true);
      return;
    }

    return socket?.emitWithAck(
      SocketEvent.startedBroadcast,
      {"broadcastId": broadcastId},
      ack: (data) => state = state.copyWith(isLive: true, loading: false),
    );
  }

  dynamic onNewBroadcast(dynamic data) {
    final Map<String, dynamic> decodedData = jsonDecode(jsonEncode(data));
    final BroadcastDto dto = BroadcastDto.fromJson(decodedData);
    final Broadcast? broadcast = _mapper.broadcastToDomain(dto);

    final liveBroadcasts = List<Broadcast?>.from(state.liveBroadcasts);
    liveBroadcasts.add(broadcast);

    state = state.copyWith(liveBroadcasts: liveBroadcasts);
  }

  dynamic onEndedBroadcast(dynamic data) {
    getLiveBroadcasts();
    state = state.copyWith(liveBroadcast: Broadcast.empty());
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
}

List<Broadcast?> _filterBroadcasts(List<Broadcast?> broadcasts, String userId) {
  if (broadcasts.isEmpty) {
    return [];
  } else {
    // Create a HashMap or LinkedHashMap to store the filtered broadcasts
    final filteredBroadcastsMap = HashMap<String, Broadcast>();

    // Filter broadcasts and add to the map
    for (final broadcast in broadcasts) {
      if (broadcast!.creator!.id != userId) {
        filteredBroadcastsMap[broadcast.id] = broadcast;
      }
    }

    // Convert the map back to a list
    final filteredBroadcastsList = filteredBroadcastsMap.values.toList();
    return filteredBroadcastsList;
  }
}

Future<List<Broadcast?>> runIsolate(
  RootIsolateToken rToken,
  List<Broadcast?> broadcasts,
  String userId,
) {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rToken);
  return Isolate.run(() => _filterBroadcasts(broadcasts, userId));
}
