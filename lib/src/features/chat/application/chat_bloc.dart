import 'dart:async';

import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/features.dart';

part 'chat_bloc.freezed.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required IChatFacade facade})
      : _facade = facade,
        super(const ChatState(chats: [])) {
    on<GetChatMessages>(_onGetChatMessages);
    on<NewChatReceived>(_onNewChatReceived);
    on<ChatDeletePressed>(_onChatDeletePressed);
    on<ChatEditPressed>(_onChatEditPressed);
    on<ChatReset>(_onChatReset);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<ContentChanged>(_onContentChanged);
    on<ClearChatContent>(_onClearChatContent);
    on<ToggleShowReactions>(_onToggleReactions);
    on<HideChatWelcomeNote>(_onHideWelcomeNote);
  }

  final IChatFacade _facade;

  Future<void> _onGetChatMessages(
    GetChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    final failureOrMessages = await _facade.getChatMessages(event.broadcastId);
    failureOrMessages.fold((failure) {}, (messages) {});
  }

  void _onNewChatReceived(NewChatReceived event, Emitter<ChatState> emit) {
    final oldMessages = List<Chat?>.from(state.chats);
    emit(state.copyWith(chats: [event.chat, ...oldMessages]));
  }

  void _onLoadChatMessages(LoadChatMessages event, Emitter<ChatState> emit) {
    emit(state.copyWith(chats: event.chats));
  }

  void _onChatDeletePressed(ChatDeletePressed event, Emitter<ChatState> emit) {}

  void _onChatEditPressed(ChatEditPressed event, Emitter<ChatState> emit) {}

  Future<void> _onChatReset(ChatReset event, Emitter<ChatState> emit) async {
    emit(const ChatState(chats: []));
  }

  void _onContentChanged(ContentChanged event, Emitter<ChatState> emit) {
    final hasContent = event.content.isNotEmpty;
    emit(state.copyWith(content: event.content, hasContent: hasContent));
  }

  void _onClearChatContent(ClearChatContent event, Emitter<ChatState> emit) {
    emit(state.copyWith(content: null));
  }

  void _onToggleReactions(ToggleShowReactions event, Emitter<ChatState> emit) {
    emit(state.copyWith(showReactions: !state.showReactions));
  }

  void _onHideWelcomeNote(HideChatWelcomeNote event, Emitter<ChatState> emit) {
    emit(state.copyWith(hideWelcomeNote: true));
  }
}
