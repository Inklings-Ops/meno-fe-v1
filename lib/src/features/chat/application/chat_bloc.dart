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
    on<ChatInitialized>(_onChatInitialized);
    on<ChatSendPressed>(_onChatSendPressed);
    on<ChatDeletePressed>(_onChatDeletePressed);
    on<ChatEditPressed>(_onChatEditPressed);
    on<ChatReset>(_onChatReset);
    on<_NewChatReceived>(_onNewChatReceived);
    on<_ChatsLoaded>(_onChatsLoaded);
  }

  final ISessionContext _session;
  final SocketService _socket;

  StreamSubscription<SocketEvent>? _socketEventSubscription;
  StreamSubscription<SocketState>? _socketStateSubscription;

  /// Tracks the initialization state of the Streams
  bool _listenersInitialized = false;

  void _onChatInitialized(ChatInitialized event, Emitter<ChatState> emit) {
    if (_listenersInitialized) return;

    emit(state.copyWith(broadcast: event.broadcast));

    _socketEventSubscription = _socket.eventsStream.listen((socketEvent) {
      socketEvent.whenOrNull(newMessage: (chat) => add(_NewChatReceived(chat)));
    });

    _socketStateSubscription = _socket.stateStream.listen((socketState) {
      socketState.whenOrNull(
        getChatMessages: (chats, _) => add(_ChatsLoaded(chats)),
      );
    });

    _socket.emit(SocketEvent.getChatMessages(event.broadcast.id.getOr()));

    _listenersInitialized = true;
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

  void _onNewChatReceived(_NewChatReceived event, Emitter<ChatState> emit) {
    final oldMessages = List<Chat?>.from(state.chats);
    emit(state.copyWith(chats: [event.chat, ...oldMessages]));
  }

  void _onChatsLoaded(_ChatsLoaded event, Emitter<ChatState> emit) {
    emit(state.copyWith(chats: event.chats));
  }

  void _onChatDeletePressed(ChatDeletePressed event, Emitter<ChatState> emit) {}

  void _onChatEditPressed(ChatEditPressed event, Emitter<ChatState> emit) {}

  Future<void> _onChatReset(ChatReset event, Emitter<ChatState> emit) async {
    await _socketEventSubscription?.cancel();
    await _socketStateSubscription?.cancel();
    _socketEventSubscription = null;
    _socketStateSubscription = null;
    _listenersInitialized = false;
    emit(ChatState.initial());
  }
}
