part of 'chat_list_bloc.dart';

sealed class ChatListEvent with EquatableMixin {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

final class ChatGetMessagesRequested extends ChatListEvent {
  const ChatGetMessagesRequested(this.broadcastId);
  final ID broadcastId;

  @override
  List<Object?> get props => [broadcastId];
}

final class ChatSendMessageRequested extends ChatListEvent {
  const ChatSendMessageRequested({
    required this.broadcastId,
    required this.content,
  });

  final ID broadcastId;
  final String content;

  @override
  List<Object?> get props => [broadcastId, content];
}

final class ChatEditMessageRequested extends ChatListEvent {
  const ChatEditMessageRequested(this.chat);
  final Chat chat; 

  @override
  List<Object?> get props => [chat];
}

final class ChatDeleteRequested extends ChatListEvent {
  const ChatDeleteRequested(this.chat);
  final Chat chat;

  @override
  List<Object?> get props => [chat];
}

final class _NewChatReceived extends ChatListEvent {
  const _NewChatReceived(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class _EditedChatReceived extends ChatListEvent {
  const _EditedChatReceived(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class _DeletedChatReceived extends ChatListEvent {
  const _DeletedChatReceived(this.data);
  final dynamic data;

  @override
  List<Object?> get props => [data];
}

final class ChatResetRequested extends ChatListEvent {
  const ChatResetRequested();
}
