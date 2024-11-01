part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.initialized(Broadcast broadcast) = ChatInitialized;
  const factory ChatEvent.chatDeletePressed(Chat chat) = ChatDeletePressed;
  const factory ChatEvent.chatEditPressed(Chat chat) = ChatEditPressed;
  const factory ChatEvent.chatSendPressed(String content) = ChatSendPressed;
  const factory ChatEvent.reset() = ChatReset;
}