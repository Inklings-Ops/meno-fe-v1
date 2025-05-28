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
    on<SocketConnectRequested>(_onConnect);
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

    socket.onConnect((_) => add(const SocketConnectRequested()));
    socket.onDisconnect((_) => add(const SocketDisconnectRequested()));
    socket.onReconnect((_) => add(const _Update(SocketReconnected())));
    socket.onReconnectAttempt((_) => add(const _Update(SocketReconnecting())));
  }

  final SocketService _socket;

  void _setupListeners() {
    if (_socket.isSocketConnected) {
      _socket.addListener(
        'newBroadcastListener',
        (data) => add(SocketNewParticipantSubscribed(data)),
      );
      _socket.addListener(
        'broadcastListenerLeft',
        (data) => add(SocketParticipantLeftSubscribed(data)),
      );
      _socket.addListener(
        'endedBroadcast',
        (data) => add(SocketEndedBroadcastSubscribed(data)),
      );
      _socket.addListener(
        'newBroadcast',
        (data) => add(SocketNewBroadcastSubscribed(data)),
      );
      _socket.addListener(
        'hostDisconnected',
        (data) => add(SocketHostDisconnectedSubscribed(data)),
      );
      _socket.addListener(
        'hostReconnected',
        (data) => add(SocketHostReconnectedSubscribed(data)),
      );
      _socket.addListener(
        'notification',
        (data) => add(SocketNotificationSubscribed(data)),
      );
      _socket.addListener(
        'editedMessage',
        (data) => add(SocketEditedChatSubscribed(data)),
      );
      _socket.addListener(
        'deletedMessage',
        (data) => add(SocketDeletedChatSubscribed(data)),
      );
    }
  }

  Future<void> _onConnect(
    SocketConnectRequested event,
    Emitter<SocketState> emit,
  ) async {
    _setupListeners();
    return emit(const SocketConnected());
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
    final dto = ParticipantDto.fromJson(eventData);
    emit(SocketNewParticipantReceived(dto.toDomain));
  }

  void _onParticipantLeftSubscribed(
    SocketParticipantLeftSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = ParticipantDto.fromJson(eventData);
    emit(SocketParticipantLeftReceived(dto.toDomain));
  }

  void _onEndedBroadcastSubscribed(
    SocketEndedBroadcastSubscribed event,
    Emitter<SocketState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final dto = EndedBroadcastData.fromJson(eventData);
    emit(SocketEndedBroadcastReceived(dto));
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
