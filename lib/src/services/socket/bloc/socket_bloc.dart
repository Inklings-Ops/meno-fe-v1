import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/core/env/env.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/value_objects/value_objects.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'socket_bloc.freezed.dart';
part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  SocketBloc() : super(const SocketDisconnected()) {
    on<SocketConnect>(_onConnect);
    on<SocketDisconnect>(_onDisconnect);
    on<SocketStartBroadcast>(_onStartBroadcast);
    on<SocketEndBroadcast>(_onEndBroadcast);
    on<SocketJoinBroadcast>(_onJoinBroadcast);
    on<SocketLeaveBroadcast>(_onLeaveBroadcast);
    on<SocketSendMessage>(_onSendMessage);
    on<_NewParticipant>(_onNewParticipant);
    on<_ParticipantLeft>(_onParticipantLeft);
    on<_EndedBroadcast>(_onEndedBroadcast);
    on<_NewBroadcast>(_onNewBroadcast);
    on<_HostDisconnected>(_onHostDisconnect);
    on<_HostReconnected>(_onHostReconnected);
    on<_Notification>(_onNotification);
    on<_NewMessage>(_onNewMessage);
    on<SocketUpdateState>(_onUpdateState);
    on<SocketGetMessages>(_onGetMessages);
  }

  io.Socket? _socket;

  Future<void> _onConnect(
    SocketConnect event,
    Emitter<SocketState> emit,
  ) async {
    _socket = io.io(
      Env.menoApiUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': event.token.getOr()})
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );
    setupListeners({
      'connect': (_) => add(const SocketUpdateState(SocketConnected())),
      'disconnect': (_) => add(const SocketUpdateState(SocketDisconnected())),
      'newBroadcastListener': (data) => add(_NewParticipant(data)),
      'broadcastListenerLeft': (data) => add(_ParticipantLeft(data)),
      'endedBroadcast': (data) => add(_EndedBroadcast(data)),
      'newBroadcast': (data) => add(_NewBroadcast(data)),
      'hostDisconnected': (data) => add(_HostDisconnected(data)),
      'hostReconnected': (data) => add(_HostReconnected(data)),
      'notification': (data) => add(_Notification(data)),
      'newMessage': (data) => add(_NewMessage(data)),
    });
  }

  void setupListeners(Map<String, void Function(dynamic)> listeners) {
    listeners.forEach((event, handler) {
      _socket?.on(event, handler);
    });
  }

  void _onDisconnect(SocketDisconnect event, Emitter<SocketState> emit) {
    _socket?.disconnect();
  }

  bool get isLoading => state is SocketLoading;

  void _onStartBroadcast(
    SocketStartBroadcast event,
    Emitter<SocketState> emit,
  ) {
    emit(const SocketLoading());
    _socket?.emitWithAck(
      'startedBroadcast',
      {'broadcastId': event.broadcastId.getOr()},
      ack: (dynamic res) {
        final response = SocketResponse.fromJson(
          res as Map<String, dynamic>,
          (json) => json as dynamic,
        );
        if (response.error != null) {
          _addUpdateState(SocketError(error: response.error!));
        } else {
          _addUpdateState(const SocketBroadcastStarted());
        }
      },
    );
  }

  void _onEndBroadcast(SocketEndBroadcast event, Emitter<SocketState> emit) {
    emit(const SocketLoading());
    _socket?.emitWithAck(
      'endBroadcast',
      {'broadcastId': event.broadcastId.getOr()},
      ack: (dynamic res) {
        final response = SocketResponse.fromJson(
          res as Map<String, dynamic>,
          (json) => json as dynamic,
        );
        if (response.error != null) {
          _addUpdateState(SocketError(error: response.error!));
        } else {
          _addUpdateState(const SocketBroadcastEnded());
        }
      },
    );
  }

  void _onJoinBroadcast(SocketJoinBroadcast event, Emitter<SocketState> emit) {
    emit(const SocketLoading());
    _socket?.emitWithAck(
      'joinBroadcast',
      {'broadcastId': event.broadcastId.getOr()},
      ack: (dynamic res) {
        final response = SocketResponse.fromJson(
          res as Map<String, dynamic>,
          (json) => json as dynamic,
        );
        if (response.error != null) {
          _addUpdateState(SocketError(error: response.error!, isStream: true));
        } else {
          _addUpdateState(const SocketBroadcastJoined());
        }
      },
    );
  }

  void _onLeaveBroadcast(
    SocketLeaveBroadcast event,
    Emitter<SocketState> emit,
  ) {
    emit(const SocketLoading());
    _socket?.emitWithAck(
      'leaveBroadcast',
      {'broadcastId': event.broadcastId.getOr()},
      ack: (dynamic res) {
        final response = SocketResponse.fromJson(
          res as Map<String, dynamic>,
          (json) => json as dynamic,
        );
        if (response.error != null) {
          _addUpdateState(SocketError(error: response.error!));
        } else {
          _addUpdateState(const SocketBroadcastLeft());
        }
      },
    );
  }

  void _onGetMessages(SocketGetMessages event, Emitter<SocketState> emit) {
    _socket?.emitWithAck(
      'getChatMessages',
      {'broadcastId': event.broadcastId.getOr()},
      ack: (dynamic res) {
        final response = SocketResponse.fromJson(
          res as Map<String, dynamic>,
          (json) => ChatListDto.fromJson(json as Map<String, dynamic>),
        );
        if (response.error != null) {
          add(SocketUpdateState(SocketError(error: response.error!)));
        } else {
          final dtos = response.data!.chatMessages;
          final chatMessages = dtos.map((chat) => chat?.toDomain).toList();
          add(SocketUpdateState(SocketMessagesReceived(chatMessages)));
        }
      },
    );
  }

  void _onSendMessage(SocketSendMessage event, Emitter<SocketState> emit) {
    _socket?.emitWithAck(
      'sendChatMessage',
      {
        'senderId': event.senderId,
        'broadcastId': event.broadcastId,
        'content': event.content,
        'createdAt': event.createdAt,
      },
    );
  }

  void _onNewParticipant(_NewParticipant event, Emitter<SocketState> emit) {
    final decoded = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
    final dto = BroadcastParticipantDto.fromJson(decoded);
    emit(SocketNewBroadcastListenerReceived(dto.toDomain));
  }

  void _onParticipantLeft(_ParticipantLeft event, Emitter<SocketState> emit) {
    final decoded = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
    final dto = BroadcastParticipantDto.fromJson(decoded);
    emit(SocketBroadcastListenerLeftReceived(dto.toDomain));
  }

  void _onEndedBroadcast(_EndedBroadcast event, Emitter<SocketState> emit) {
    final decoded = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
    final dto = EndedBroadcastDataDto.fromJson(decoded);
    emit(SocketEndedBroadcastReceived(dto.toDomain));
  }

  void _onNewBroadcast(_NewBroadcast event, Emitter<SocketState> emit) {
    final decoded = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
    final dto = BroadcastDto.fromJson(decoded);
    emit(SocketNewBroadcastReceived(dto.toDomain));
  }

  void _onHostDisconnect(_HostDisconnected event, Emitter<SocketState> emit) {
    final value = jsonDecode(jsonEncode(event.data)) as bool;
    emit(SocketHostDisconnectedReceived(value));
  }

  void _onHostReconnected(_HostReconnected event, Emitter<SocketState> emit) {
    final value = jsonDecode(jsonEncode(event.data)) as bool;
    emit(SocketReconnectedReceived(value));
  }

  void _onNotification(_Notification event, Emitter<SocketState> emit) {
    final decoded = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
    final dto = NotificationDto.fromJson(decoded);
    emit(SocketNotificationReceived(dto.toDomain));
  }

  void _onNewMessage(_NewMessage event, Emitter<SocketState> emit) {
    final decoded = jsonDecode(jsonEncode(event.data)) as Map<String, dynamic>;
    final dto = ChatDto.fromJson(decoded);
    emit(SocketNewMessageReceived(dto.toDomain));
  }

  void _onUpdateState(SocketUpdateState event, Emitter<SocketState> emit) {
    emit(event.newState);
  }

  void _addUpdateState(SocketState state) => add(SocketUpdateState(state));
}
