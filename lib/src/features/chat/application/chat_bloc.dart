import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'chat_bloc.freezed.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required IChatFacade facade})
      : _facade = facade,
        super(const ChatInitial()) {
    on<GetChatMessages>(_onGetChatMessages);
    on<NewChatReceived>(_onNewChatReceived);
    on<ChatDeletePressed>(_onChatDeletePressed);
    on<ChatEditPressed>(_onChatEditPressed);
    on<ChatReset>(_onChatReset);
  }

  final IChatFacade _facade;

  Future<void> _onGetChatMessages(
    GetChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoadInProgress());
    final failureOrMessages = await _facade.getChatMessages(event.broadcastId);
    failureOrMessages.fold(
      (failure) => emit(ChatLoadFailed(failure)),
      (messages) => emit(ChatLoadSuccess(messages)),
    );
  }

  void _onNewChatReceived(NewChatReceived event, Emitter<ChatState> emit) {
    if (state is ChatLoadSuccess) {
      final oldMessages = List<Chat?>.from((state as ChatLoadSuccess).chats);
      emit(ChatLoadSuccess([event.chat, ...oldMessages]));
    }
  }

  void _onChatDeletePressed(ChatDeletePressed event, Emitter<ChatState> emit) {}

  void _onChatEditPressed(ChatEditPressed event, Emitter<ChatState> emit) {}

  Future<void> _onChatReset(ChatReset event, Emitter<ChatState> emit) async {
    emit(const ChatInitial());
  }
}
