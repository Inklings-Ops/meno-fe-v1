import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  SocketBloc({required SocketService socket})
      : _socket = socket,
        super(const SocketDisconnected()) {
    on<SocketDisconnectRequested>(_onDisconnect);
    on<SocketUpdateStateRequested>(_onUpdateState);
    on<SocketNewParticipantSubscribed>(_onNewParticipantSubscribed);
    on<SocketParticipantLeftSubscribed>(_onParticipantLeftSubscribed);
    on<SocketEndedBroadcastSubscribed>(_onEndedBroadcastSubscribed);
    on<SocketNewBroadcastSubscribed>(_onNewBroadcastSubscribed);
    on<SocketHostDisconnectedSubscribed>(_onHostDisconnectSubscribed);
    on<SocketHostReconnectedSubscribed>(_onHostReconnectedSubscribed);
    on<SocketNotificationSubscribed>(_onNotificationSubscribed);
    on<SocketEditedChatSubscribed>(_onEditedChatSubscribed);
    on<SocketDeletedChatSubscribed>(_onDeletedChatSubscribed);

    _setupListeners();
  }

  final SocketService _socket;

  void _setupListeners() {
    _socket
      ..addListener(
        'connect',
        (_) => add(const SocketUpdateStateRequested(SocketConnected())),
      )
      ..addListener(
        'disconnect',
        (_) => add(const SocketUpdateStateRequested(SocketDisconnected())),
      )
      ..addListener(
        'newBroadcastListener',
        (data) => add(SocketNewParticipantSubscribed(data)),
      )
      ..addListener(
        'broadcastListenerLeft',
        (data) => add(SocketParticipantLeftSubscribed(data)),
      )
      ..addListener(
        'endedBroadcast',
        (data) => add(SocketEndedBroadcastSubscribed(data)),
      )
      ..addListener(
        'newBroadcast',
        (data) => add(SocketNewBroadcastSubscribed(data)),
      )
      ..addListener(
        'hostDisconnected',
        (data) => add(SocketHostDisconnectedSubscribed(data)),
      )
      ..addListener(
        'hostReconnected',
        (data) => add(SocketHostReconnectedSubscribed(data)),
      )
      ..addListener(
        'notification',
        (data) => add(SocketNotificationSubscribed(data)),
      )
      ..addListener(
        'editedMessage',
        (data) => add(SocketEditedChatSubscribed(data)),
      )
      ..addListener(
        'deletedMessage',
        (data) => add(SocketDeletedChatSubscribed(data)),
      );
  }

  void _onDisconnect(
    SocketDisconnectRequested event,
    Emitter<SocketState> emit,
  ) {
    _socket.disconnect();
  }

  void _onNewParticipantSubscribed(
    SocketNewParticipantSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = BroadcastParticipantDto.fromJson(eventData);
    emit(SocketNewParticipantReceived(dto.toDomain));
  }

  void _onParticipantLeftSubscribed(
    SocketParticipantLeftSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = BroadcastParticipantDto.fromJson(eventData);
    emit(SocketParticipantLeftReceived(dto.toDomain));
  }

  void _onEndedBroadcastSubscribed(
    SocketEndedBroadcastSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = EndedBroadcastDataDto.fromJson(eventData);
    emit(SocketEndedBroadcastReceived(dto.toDomain));
  }

  void _onNewBroadcastSubscribed(
    SocketNewBroadcastSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = BroadcastDto.fromJson(eventData);
    emit(SocketNewBroadcastReceived(dto.toDomain));
  }

  void _onHostDisconnectSubscribed(
    SocketHostDisconnectedSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final value = jsonDecode(jsonEncode(event.data)) as bool;
    emit(SocketHostDisconnectedReceived(value));
  }

  void _onHostReconnectedSubscribed(
    SocketHostReconnectedSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final value = jsonDecode(jsonEncode(event.data)) as bool;
    emit(SocketHostReconnectedReceived(value));
  }

  void _onNotificationSubscribed(
    SocketNotificationSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = NotificationDto.fromJson(eventData);
    emit(SocketNotificationReceived(dto.toDomain));
  }

  void _onEditedChatSubscribed(
    SocketEditedChatSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = ChatDto.fromJson(eventData);
    emit(SocketEditedChatReceived(dto.toDomain));
  }

  void _onDeletedChatSubscribed(
    SocketDeletedChatSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = ChatDto.fromJson(eventData);
    emit(SocketDeletedChatReceived(dto.toDomain));
  }

  void _onUpdateState(
    SocketUpdateStateRequested event,
    Emitter<SocketState> emit,
  ) {
    emit(event.newState);
  }
}
