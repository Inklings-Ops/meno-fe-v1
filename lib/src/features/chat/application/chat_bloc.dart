import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/domain/domain.dart';
import 'package:meno_fe_v1/src/features/profile/profile.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

part 'chat_bloc.freezed.dart';
part 'chat_state.dart';

@lazySingleton
class ChatBloc extends Cubit<ChatState> {
  ChatBloc({
    required ISessionContext session,
    required SocketService socket,
    required IProfileFacade profileFacade,
  })  : _session = session,
        _socket = socket,
        _profileFacade = profileFacade,
        super(ChatState.initial()) {
    _socketStateSub = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        getChatMessages: (chats, _) => emit(state.copyWith(
          chats: chats,
          loading: false,
        ),),
      );
    });
    _socketEventSub = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(
        newMessage: _updateMessages,
      );
    });
  }
  final ISessionContext _session;
  final SocketService _socket;
  final IProfileFacade _profileFacade;
  late final StreamSubscription<SocketEvent> _socketEventSub;
  late final StreamSubscription<SocketState> _socketStateSub;

  Future<void> initialize(Broadcast broadcast) async {
    emit(state.copyWith(loading: true, broadcast: broadcast));
    _socket.emit(SocketEvent.getChatMessages(state.broadcast.id.getOr()));
  }

  Future<void> deleteMessage(Chat chat) async {
    Logger().f(chat);
  }

  Future<void> editMessage({
    required String content,
    required Uid<Broadcast> broadcastId,
  }) async {}

  Future<void> getRecentMessages({
    required Uid<Broadcast> id,
    int? page,
    int? size,
  }) async {}

  Future<void> sendMessage(String content) async {
    final credential = _session.credential;
    Logger().w('SENDER_ID => ${credential!.user.id.getOr()}');
    Logger().w('BROADCAST_ID => ${state.broadcast.id.getOr()}');
    Logger().w('CONTENT => $content');
    Logger().w('CREATED_AT => ${DateTime.now().toIso8601String()}');
    _socket.emit(
      SocketEvent.sendChatMessage(
        senderId: credential.user.id.getOr(),
        broadcastId: state.broadcast.id.getOr(),
        content: content,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<void> _updateMessages(Chat chat) async {
    final oldMessages = List<Chat?>.from(state.chats);
    emit(state.copyWith(chats: [chat, ...oldMessages]));
  }

  Future<Profile?> getSenderInfo(String senderId) async {
    final fOrP = await _profileFacade.getProfile(senderId);
    return fOrP.fold((_) => null, (profile) => profile);
  }

  @override
  Future<void> close() {
    _socketEventSub.cancel();
    _socketStateSub.cancel();
    return super.close();
  }
}
