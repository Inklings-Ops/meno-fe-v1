part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.getChatMessages(
    Uid<Broadcast> broadcastId,
  ) = GetChatMessages;

  const factory ChatEvent.loadMessages(List<Chat?> chats) = LoadChatMessages;

  const factory ChatEvent.newChatReceived(Chat chat) = NewChatReceived;

  const factory ChatEvent.chatDeletePressed(Chat chat) = ChatDeletePressed;

  const factory ChatEvent.chatEditPressed(Chat chat) = ChatEditPressed;

  const factory ChatEvent.reset() = ChatReset;
}
