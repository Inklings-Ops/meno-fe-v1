import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:meno_fe_v1/src/services/services.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

@lazySingleton
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required ISessionContext session,
    required SocketService socket,
  })  : _session = session,
        _socket = socket,
        super(ChatState.initial()) {
    on<ChatEvent>((event, emit) {});
    on<ChatInitialized>(_onChatInitialized);
    on<ChatSendPressed>(_onChatSendPressed);
    on<ChatDeletePressed>(_onChatDeletePressed);
    on<ChatEditPressed>(_onChatEditPressed);
    on<ChatReset>(_onChatReset);
  }

  final ISessionContext _session;
  final SocketService _socket;

  late final StreamSubscription<SocketEvent>? _socketEventSubscription;
  late final StreamSubscription<SocketState>? _socketStateSubscription;

  void _onChatInitialized(ChatInitialized event, Emitter<ChatState> emit) {
    if (_socketEventSubscription == null || _socketStateSubscription == null) {
      emit(state.copyWith(broadcast: event.broadcast));

      _socketEventSubscription = _socket.eventsStream.listen((socketEvent) {
        socketEvent.whenOrNull(
          newMessage: (chat) {
            final oldMessages = List<Chat?>.from(state.chats);
            emit(state.copyWith(chats: [chat, ...oldMessages]));
          },
        );
      });

      _socketStateSubscription = _socket.stateStream.listen((socketState) {
        socketState.whenOrNull(
          getChatMessages: (chats, _) {
            emit(state.copyWith(chats: chats, status: ChatStatus.success));
          },
        );
      });

      _socket.emit(SocketEvent.getChatMessages(event.broadcast.id.getOr()));
    }
  }

  void _onChatSendPressed(ChatSendPressed event, Emitter<ChatState> emit) {
    final authenticatedUserId = _session.credential!.user.id.getOr();
    _socket.emit(
      SocketEvent.sendChatMessage(
        senderId: authenticatedUserId,
        broadcastId: state.broadcast.id.getOr(),
        content: event.content,
        createdAt: DateTime.timestamp().toIso8601String(),
      ),
    );
  }

  void _onChatDeletePressed(ChatDeletePressed event, Emitter<ChatState> emit) {}

  void _onChatEditPressed(ChatEditPressed event, Emitter<ChatState> emit) {}

  Future<void> _onChatReset(ChatReset event, Emitter<ChatState> emit) async {
    await _socketEventSubscription?.cancel();
    await _socketStateSubscription?.cancel();
    _socketEventSubscription = null;
    _socketStateSubscription = null;
    emit(ChatState.initial());
  }
}
