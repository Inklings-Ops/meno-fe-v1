import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../services/socket/socket_service.dart';
import '../../auth/domain/domain.dart';
import '../domain/domain.dart';
import '../infrastructure/dtos/chat_dto.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

@lazySingleton
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IAuthFacade _facade;
  final SocketService _socket;

  ChatBloc({
    required IAuthFacade facade,
    required SocketService socket,
  })  : _facade = facade,
        _socket = socket,
        super(ChatState.initial()) {
    on<_GetMessages>(_onGetMessages);
    on<_GetRecentMessages>(_onGetRecentMessages);
    on<_DeleteMessage>(_onDeleteMessage);
    on<_UpdateMessages>(_onUpdateMessages);
    on<_SendMessage>(_onSendMessage);
    on<_EditMessage>(_onEditMessage);
  }

  @postConstruct
  void init() {
    _socket.on('newMessage', (data) => _UpdateMessages(data));
  }

  Future<void> _onDeleteMessage(_DeleteMessage event, emit) async {}

  Future<void> _onEditMessage(_EditMessage event, emit) async {}

  Future<void> _onGetMessages(_GetMessages event, emit) async {
    emit(state.copyWith(loading: true));
    final completer = Completer<dynamic>();

    _socket.emitWithAck(
      'getChatMessages',
      {'broadcastId': event.broadcastId},
      ack: completer.complete,
    );

    await completer.future.then((value) {
      Logger().w(value);
      final res = value['data']['chatMessages'] as List;
      final list = res.map((e) => ChatDto.fromJson(e).toDomain).toList();

      if (list.isEmpty == true) {
        return emit(state.copyWith(chats: []));
      } else {
        return emit(state.copyWith(chats: list));
      }
    });
  }

  Future<void> _onGetRecentMessages(_GetRecentMessages event, emit) async {}

  Future<void> _onSendMessage(_SendMessage event, emit) async {
    final completer = Completer<dynamic>();

    final credential = await _facade.credential;

    _socket.emitWithAck(
      'sendChatMessage',
      {
        'senderId': credential?.user.id,
        'broadcastId': event.broadcastId,
        'content': event.content,
        'createdAt': DateTime.now().toIso8601String(),
      },
      ack: completer.complete,
    );

    return await completer.future.then((value) {
      if (value['error'] != null) return;
      return emit(state.copyWith(onSend: some(unit)));
    });
  }

  Future<void> _onUpdateMessages(_UpdateMessages event, emit) async {
    final dto = ChatDto.fromJson(event.data);
    final oldMessages = List<Chat?>.from(state.chats);
    emit(state.copyWith(chats: [dto.toDomain, ...oldMessages]));
  }
}
