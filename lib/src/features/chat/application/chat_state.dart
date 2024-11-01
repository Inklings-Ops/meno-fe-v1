part of 'chat_bloc.dart';

enum ChatStatus { initial, success, failure }

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required Broadcast broadcast,
    required List<Chat?> chats,
    @Default(ChatStatus.initial) ChatStatus status,
  }) = _ChatState;

  factory ChatState.initial() => ChatState(
        broadcast: Broadcast.empty(),
        chats: [],
      );
}
