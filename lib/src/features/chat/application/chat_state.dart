part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required bool loading,
    required List<Chat?> chats,
    required Option<Unit> onSend,
  }) = _ChatState;

  factory ChatState.initial() {
    return ChatState(
      chats: [],
      loading: false,
      onSend: none(),
    );
  }
}
