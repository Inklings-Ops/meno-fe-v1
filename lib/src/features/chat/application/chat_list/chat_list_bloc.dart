// ignore_for_file: avoid_redundant_argument_values

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/core/exceptions/exceptions.dart';
import 'package:meno_fe_v1/src/core/response/response.dart'
    show BaseResponse, PaginatedList;
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/services/socket/socket_service.dart';
import 'package:meno_fe_v1/src/shared/shared.dart' show ID, ISessionContext;

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc({
    required SocketService socket,
    required ISessionContext session,
  })  : _socket = socket,
        _session = session,
        super(const ChatListState()) {
    on<ChatGetMessagesRequested>(_onGetMessagesRequested);
    on<ChatSendMessageRequested>(_onChatSendMessageRequested);
    on<ChatEditMessageRequested>(_onChatEditMessageRequested);
    on<ChatDeleteRequested>(_onChatDeleteRequested);
    on<ChatResetRequested>(_onResetRequested);
    on<_NewChatReceived>(_onNewChatReceived);
    on<_EditedChatReceived>(_onEditedChatReceived);
    on<_DeletedChatReceived>(_onDeletedChatReceived);

    socket.addListener('newMessage', (c) => add(_NewChatReceived(c)));
    socket.addListener('editedMessage', (c) => add(_EditedChatReceived(c)));
    socket.addListener('deletedMessage', (c) => add(_DeletedChatReceived(c)));
  }

  final SocketService _socket;
  final ISessionContext _session;

  Future<void> _onGetMessagesRequested(
    ChatGetMessagesRequested event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading, exception: null));

    final socketResult = await _socket.emit(
      'getChatMessages',
      {'broadcastId': event.broadcastId.getOrCrash()},
    );

    final response = BaseResponse<PaginatedChatMessages<ChatDto?>>.fromJson(
      socketResult as Map<String, dynamic>,
      (json) => PaginatedChatMessages<ChatDto?>.fromJson(
        json! as Map<String, dynamic>,
        (json) => json == null
            ? null
            : ChatDto.fromJson(json as Map<String, dynamic>),
      ),
    );

    final socketError = response.error;
    if (socketError != null) {
      final error = _socket.getErrorMessage(socketError);
      emit(
        state.copyWith(
          exception: ChatExceptionWithMessage(error.message.toString()),
          status: ChatListStatus.failure,
        ),
      );
    } else {
      final data = response.data!;
      final paginatedList = PaginatedList(
        items: data.chatMessages.map((dto) => dto?.toDomain).toList(),
        currentPage: data.currentPage,
        totalItems: data.totalItems,
        totalPages: data.totalPages,
      );
      emit(
        state.copyWith(
          chats: paginatedList.items,
          currentPage: paginatedList.currentPage,
          totalPages: paginatedList.totalPages,
          moreInProgress: false,
          hasMore: paginatedList.currentPage < paginatedList.totalPages,
        ),
      );
    }

    // emit(
    //   messagesOrFailure.fold(
    //     (exception) => state.copyWith(
    //       exception: exception,
    //       status: ChatListStatus.failure,
    //     ),
    //     (paginatedList) => state.copyWith(
    //       chats: paginatedList.items,
    //       currentPage: paginatedList.currentPage,
    //       totalPages: paginatedList.totalPages,
    //       moreInProgress: false,
    //       hasMore: paginatedList.currentPage < paginatedList.totalPages,
    //     ),
    //   ),
    // );
  }

  void _onNewChatReceived(_NewChatReceived event, Emitter<ChatListState> emit) {
    final eventData = event.data as Map<String, dynamic>;
    final chat = ChatDto.fromJson(eventData).toDomain;
    final oldChats = List<Chat?>.from(state.chats);
    emit(state.copyWith(chats: [chat, ...oldChats]));
  }

  void _onEditedChatReceived(
    _EditedChatReceived event,
    Emitter<ChatListState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final chat = ChatDto.fromJson(eventData).toDomain;

    final chats = List<Chat?>.from(state.chats);
    final updatedChats = chats.map((c) => c?.id == chat.id ? chat : c).toList();
    emit(state.copyWith(chats: updatedChats));
  }

  void _onDeletedChatReceived(
    _DeletedChatReceived event,
    Emitter<ChatListState> emit,
  ) {
    final eventData = event.data as Map<String, dynamic>;
    final chat = ChatDto.fromJson(eventData).toDomain;

    final chats = List<Chat?>.from(state.chats);
    final updatedChats = chats.where((c) => c?.id != chat.id).toList();
    emit(state.copyWith(chats: updatedChats));
  }

  void _onResetRequested(
    ChatResetRequested event,
    Emitter<ChatListState> emit,
  ) {
    return emit(const ChatListState());
  }

  Future<void> _onChatDeleteRequested(
    ChatDeleteRequested event,
    Emitter<ChatListState> emit,
  ) async {
    final chat = event.chat;

    // Optimistically update the UI
    final chats = List<Chat?>.from(state.chats);
    final updatedChats = chats.where((c) => c?.id != chat.id).toList();
    emit(state.copyWith(chats: updatedChats));

    try {
      final data = {
        'id': chat.id,
        'senderId': chat.senderId,
        'broadcastId': chat.broadcastId,
        'content': chat.content,
        'createdAt': chat.createdAt,
      };
      final ack = await _socket.emit('deleteChatMessage', data);
      final response = BaseResponse.fromJson(
        ack as Map<String, dynamic>,
        (json) => json as dynamic,
      );

      if (response.error != null) {
        log('Chat deleting failed');
        emit(state.copyWith(chats: chats));
      } else {
        // Success via Ack - message sent to server.
        // Now we wait for _onNewChatReceived.
        log('Chat:${chat.id} => Message deleted.');
      }
    } catch (e) {
      log('Chat deleting failed = $e');
      emit(state.copyWith(chats: chats));
    }
  }

  Future<void> _onChatSendMessageRequested(
    ChatSendMessageRequested event,
    Emitter<ChatListState> emit,
  ) async {
    final content = event.content.trim();
    final broadcastId = event.broadcastId;
    final now = DateTime.timestamp().toIso8601String();
    final user = _session.credential?.user;

    if (user == null || content.isEmpty) {
      log('sendMessage aborted: User not logged in or content empty.');
      return;
    }

    try {
      final payload = {
        'senderId': user.id.getOrCrash(),
        'broadcastId': broadcastId.getOrCrash(),
        'content': content,
        'createdAt': now,
      };

      final ack = await _socket.emit('sendChatMessage', payload);

      final response = BaseResponse.fromJson(
        ack as Map<String, dynamic>,
        (json) => json as dynamic,
      );

      if (response.error != null) {
        log('Sending failed. Error: ${response.error}');
      } else {
        // Success via Ack - message sent to server.
        // Now we wait for _onNewMessage or timeout.
        log('Sending successful.');
      }
    } catch (e) {
      log('Exception message or processing Ack: $e');
    }
  }

  Future<void> _onChatEditMessageRequested(
    ChatEditMessageRequested event,
    Emitter<ChatListState> emit,
  ) async {
    final chat = event.chat;
    final updatedAt = DateTime.timestamp().toIso8601String();
    final user = _session.credential?.user;

    if (user == null || !chat.content.isValid) {
      log('editChatMessage aborted: User not logged in or content empty.');
      return;
    }

    try {
      final payload = {
        'id': chat.id.getOrCrash(),
        'senderId': user.id.getOrCrash(),
        'broadcastId': chat.broadcastId.getOrCrash(),
        'content': chat.content.getOrCrash(),
        'createdAt': chat.createdAt.toIso8601String(),
        'updatedAt': updatedAt,
      };

      final ack = await _socket.emit('editChatMessage', payload);

      final response = BaseResponse.fromJson(
        ack as Map<String, dynamic>,
        (json) => json as dynamic,
      );

      if (response.error != null) {
        log('Sending failed. Error: ${response.error}');
      } else {
        // Success via Ack - message sent to server.
        // Now we wait for _onNewMessage or timeout.
        log('Sending edited message successful.');
      }
    } catch (e) {
      log('Exception message or processing Ack: $e');
    }
  }
}
