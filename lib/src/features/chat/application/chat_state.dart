part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required List<Chat?> chats,
    required Broadcast broadcast,
    @Default(false) bool hasContent,
    @Default(false) bool showReactions,
    @Default(false) bool hideWelcomeNote,
    String? content,
  }) = _ChatState;
}
