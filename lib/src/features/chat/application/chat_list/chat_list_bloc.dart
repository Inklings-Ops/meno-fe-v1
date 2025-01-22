import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';
part 'chat_list_bloc.freezed.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(ChatListState(broadcast: Broadcast.empty())) {
    on<InitializeChatList>(_onInitialize);
    on<NewChatReceived>(_onNewChatReceived);
    on<EditedChatReceived>(_onEditedChatReceived);
    on<DeletedChatRemoved>(_onChatDelete);
    on<ChatReset>(_onChatReset);
    on<LoadChatMessages>(_onLoadMessages);
    on<ToggleShowReactions>(_onToggleReactions);
  }

  final _initialState = ChatListState(chats: [], broadcast: Broadcast.empty());

  void _onInitialize(InitializeChatList event, Emitter<ChatListState> emit) {
    emit(state.copyWith(broadcast: event.broadcast));
  }

  void _onNewChatReceived(NewChatReceived event, Emitter<ChatListState> emit) {
    final oldMessages = List<Chat?>.from(state.chats);
    emit(state.copyWith(chats: [event.chat, ...oldMessages]));
  }

  void _onEditedChatReceived(
    EditedChatReceived event,
    Emitter<ChatListState> emit,
  ) {
    final oldMessages = List<Chat?>.from(state.chats);
    final updatedChats = oldMessages.map((chat) {
      if (chat?.id == event.chat.id) return event.chat;
      return chat;
    }).toList();
    emit(state.copyWith(chats: updatedChats));
  }

  void _onLoadMessages(LoadChatMessages event, Emitter<ChatListState> emit) {
    emit(state.copyWith(chats: event.chats));
  }

  void _onChatDelete(DeletedChatRemoved event, Emitter<ChatListState> emit) {
    final oldMessages = List<Chat?>.from(state.chats);
    final updatedMessages =
        oldMessages.where((chat) => chat?.id != event.chat.id).toList();
    emit(state.copyWith(chats: updatedMessages));
  }

  void _onChatReset(ChatReset event, Emitter<ChatListState> emit) {
    emit(_initialState);
  }

  void _onToggleReactions(
    ToggleShowReactions event,
    Emitter<ChatListState> emit,
  ) {
    emit(state.copyWith(showReactions: !state.showReactions));
  }
}
