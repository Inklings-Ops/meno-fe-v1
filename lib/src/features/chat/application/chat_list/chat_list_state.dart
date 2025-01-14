part of 'chat_list_bloc.dart';

@freezed
class ChatListState with _$ChatListState {
  const factory ChatListState({
    required Broadcast broadcast,
    @Default([]) List<Chat?> chats,
    @Default(false) bool hasContent,
    @Default(false) bool showReactions,
   }) = _ChatListState;
}
