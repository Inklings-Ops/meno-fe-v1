part of 'chat_list_bloc.dart';

@freezed
class ChatListEvent with _$ChatListEvent {
  const factory ChatListEvent.initialize(Broadcast broadcast) =
      InitializeChatList;

  const factory ChatListEvent.loadMessages(List<Chat?> chats) =
      LoadChatMessages;

  const factory ChatListEvent.newChatReceived(Chat chat) = NewChatReceived;

  const factory ChatListEvent.chatDeletePressed(Chat chat) = ChatDeletePressed;

  const factory ChatListEvent.reset() = ChatReset;

  const factory ChatListEvent.toggleShowReactions() = ToggleShowReactions;
}
